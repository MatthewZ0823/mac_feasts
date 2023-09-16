import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

import 'package:mac_feasts/api/locations.dart';
import 'package:mac_feasts/api/schedule.dart';

class Restaurant {
  final String name;
  final String? location;
  final Schedule? schedule;

  Restaurant(this.name, this.location, this.schedule);

  /// Searches [div] and creates a restaurant if found
  factory Restaurant.fromRestaurantDiv(Element div) {
    var name = div.querySelector('.title')?.innerHtml;
    var location = div.querySelector('.location')?.innerHtml;
    var scheduleEl = div.querySelector('.schedule');

    if (name == null) throw Exception('Could not parse restaurant from div');

    if (name.contains('<span')) {
      name = name.substring(0, name.indexOf('<span'));
      name = name.trim();
    }

    var schedule =
        scheduleEl == null ? null : Schedule.fromScheduleDiv(scheduleEl);

    return Restaurant(name, location, schedule);
  }

  /// Checks if this restaurant is open at [time]
  bool isOpen(DateTime time) {
    if (schedule == null || schedule!.hours.isEmpty) return false;

    return schedule!.hours.any((hours) {
      return hours.start != null &&
          hours.end != null &&
          hours.start!.isBefore(time) &&
          hours.end!.isAfter(time);
    });
  }

  @override
  String toString() {
    return "Name: $name, Location: $location";
  }

  /// Gets all the restaurants in [document]. [document] should come from a locations page
  /// Ex. https://maceats.mcmaster.ca/locations/david-braley-athletic-centre
  static List<Restaurant> getRestaurantsFromDocument(Document document) {
    var mainContentEl = document.querySelectorAll('.unit');

    return mainContentEl
        .map((locationDiv) => Restaurant.fromRestaurantDiv(locationDiv))
        .toList();
  }

  /// Gets all the restaurants in [location]. Makes an http request
  static Future<List<Restaurant>> getRestaurantsFromLocation(
      Location location) async {
    var response = await http.get(location.url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch from MacEats');
    }

    var document = html_parser.parse(response.body);
    var foo = getRestaurantsFromDocument(document);

    return foo;
  }
}
