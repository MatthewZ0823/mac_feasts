import 'package:flutter/material.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_filters.dart';
import 'package:mac_feasts/components/restaurant/restaurant_tile.dart';

enum TimeFilter { now, anytime }

class RestaurantList extends StatefulWidget {
  const RestaurantList({
    super.key,
    required this.restaurants,
  });

  final List<Restaurant>? restaurants;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  var displayedRestaurants = <Restaurant>[];

  List<Restaurant> filterRestaurants(TimeFilter? filter) {
    switch (filter) {
      case TimeFilter.now:
        return widget.restaurants!.where((restaurant) {
          return restaurant.isOpen(DateTime.now());
        }).toList();
      case TimeFilter.anytime:
        return widget.restaurants ?? <Restaurant>[];
      default:
        throw UnimplementedError(
            'Time Filter $filter has not yet been implemented');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.restaurants == null || widget.restaurants!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    var listTiles = [
      const SizedBox(height: 10.0),
      RestaurantFilters(
        onTimeFilter: (filter) => setState(() {
          displayedRestaurants = filterRestaurants(filter);
        }),
      ),
      ...displayedRestaurants.map((restaurant) {
        return RestaurantTile(restaurant: restaurant);
      }).toList(),
      const SizedBox(height: 10.0),
    ];

    return ListView(children: listTiles);
  }
}
