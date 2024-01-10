import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/api/eats.dart';

class RestaurantState extends ChangeNotifier {
  final _restaurants = <Restaurant>[];

  RestaurantState() {
    _initializeRestaurants();
  }

  UnmodifiableListView<Restaurant> get restaurants =>
      UnmodifiableListView(_restaurants);

  /// Makes http requests to get all the restaurants to populate the state
  void _initializeRestaurants() async {
    _restaurants.addAll(await getAllRestaurants());
    notifyListeners();
  }
}
