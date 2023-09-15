import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'dart:developer' as developer;

import 'package:mac_feasts/api/locations.dart';
import 'package:mac_feasts/api/restaurant.dart';

class Eats {
  Future<String> fetch() async {
    var response = await http.get(Uri.https('maceats.mcmaster.ca', 'open-now'));

    if (response.statusCode == 200) {
      developer.log(response.body);
      return response.body;
    } else {
      throw Exception('Failed to fetch from MacEats');
    }
  }

  Future<List<Location>> getAllLocations() async {
    var response =
        await http.get(Uri.https('maceats.mcmaster.ca', 'locations'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch from MacEats');
    }

    var document = html_parser.parse(response.body);
    var locations = Location.getLocationsFromDocument(document);

    return locations;
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    var locations = await getAllLocations();
    List<Future<List<Restaurant>>> locationCalls = [];
    List<Restaurant> restaurants = [];

    for (final location in locations) {
      locationCalls.add(Restaurant.getRestaurantsFromLocation(location));
    }

    List responses = await Future.wait(locationCalls);
    for (final response in responses) {
      restaurants.addAll(response);
    }

    return restaurants;
  }
}
