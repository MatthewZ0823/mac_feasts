import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart';
import 'package:mac_feasts/api/locations.dart';
import 'package:mac_feasts/api/restaurant.dart';

class RestaurantState extends ChangeNotifier {
  final _restaurants = <Restaurant>[];

  RestaurantState() {
    _initializeRestaurants();
  }

  UnmodifiableListView<Restaurant> get restaurants =>
      UnmodifiableListView(_restaurants);

  Future<List<Location>> _getAllLocations() async {
    var response =
        await http.get(Uri.https('maceats.mcmaster.ca', 'locations'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch from MacEats');
    }

    var document = html_parser.parse(response.body);
    var locations = Location.getLocationsFromDocument(document);

    return locations;
  }

  /// Makes http requests to get all the restaurants to populate the state
  void _initializeRestaurants() async {
    var locations = await _getAllLocations();

    for (final location in locations) {
      Restaurant.getRestaurantsFromLocation(location)
          .then((restaurants) => _handleRestaurants(restaurants));
    }
  }

  void _handleRestaurants(List<Restaurant> restaurants) {
    _restaurants.addAll(restaurants);
    notifyListeners();
  }
}
