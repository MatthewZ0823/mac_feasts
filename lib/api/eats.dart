import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/api/web_parser.dart';

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

/// Get a list of all restaurants from maceats
Future<List<Restaurant>> getAllRestaurants() async {
  var restaurants = <Restaurant>[];
  var input = await _fetchCalendarString(DateTime.now());
  var document = html_parser.parse(input);

  var rows = document.querySelectorAll('tr.s-lc-whw-loc');

  for (final row in rows) {
    restaurants.add(restaurantFromTableRow(row));
  }

  return restaurants;
}

/// Update [restaurants] schedules with the opening times for the week of [date]
void updateSchedules(DateTime date, List<Restaurant> restaurants) async {
  var input = await _fetchCalendarString(date);
  var document = html_parser.parse(input);

  var rows = document.querySelectorAll('tr.s-lc-whw-loc');

  for (final row in rows) {
    var newRestaurant = restaurantFromTableRow(row);

    try {
      var oldRestaurant = restaurants
          .firstWhere((element) => element.name == newRestaurant.name);

      oldRestaurant.schedule?.openingTimes
          .addAll(newRestaurant.schedule?.openingTimes ?? []);
    } on StateError {
      // Old restaurant not found
      continue;
    }
  }
}
