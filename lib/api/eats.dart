import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/api/schedule.dart';
import 'package:mac_feasts/api/web_parser.dart';
import 'package:mac_feasts/utils/dates.dart';

/// Makes a GET request to maceats and returns the body of the html
Future<String> _fetchCalendarString(DateTime date) async {
  var formattedDate = DateFormat('yyyy-MM-dd').format(date);
  var response = await http.get(Uri.https('hospitality-mcmaster.libcal.com',
      '/widget/hours/grid', {'date': formattedDate}));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch from MacEats');
  }
}

/// Retrieves a list of all restaurants available from Maceats for the week of [date].
Future<List<Restaurant>> getAllRestaurants(DateTime date) async {
  var restaurants = <Restaurant>[];
  var input = await _fetchCalendarString(date);
  var document = html_parser.parse(input);

  var rows = document.querySelectorAll('tr.s-lc-whw-loc');

  for (final row in rows) {
    restaurants.add(restaurantFromTableRow(row, getWeekStart(date)));
  }

  return restaurants;
}

/// Update [restaurants]'s schedules with [weekStart]'s opening times
Future<List<Restaurant>> updateRestaurantSchedules(
    List<Restaurant> restaurants, DateTime weekStart) async {
  var newRestaurants = await getAllRestaurants(weekStart);

  return restaurants.map((restaurant) {
    var matchingRestaurant =
        newRestaurants.firstWhere((el) => el.name == restaurant.name);

    var newScheduleOpeningTimes = [
      ...restaurant.schedule.openingTimes,
      ...matchingRestaurant.schedule.openingTimes
    ];
    var newScrapedWeeks = [...restaurant.schedule.scrapedWeeks, weekStart];

    var newSchedule = Schedule(newScheduleOpeningTimes, newScrapedWeeks);

    return Restaurant(restaurant.name, restaurant.location, newSchedule);
  }).toList();
}
