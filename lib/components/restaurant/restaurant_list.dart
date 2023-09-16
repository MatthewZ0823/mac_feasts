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

  @override
  Widget build(BuildContext context) {
    if (widget.restaurants == null || widget.restaurants!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    handleTimeFilter(TimeFilter? value) {
      switch (value) {
        case TimeFilter.now:
          setState(() {
            displayedRestaurants = widget.restaurants!.where((restaurant) {
              if (restaurant.schedule == null ||
                  restaurant.schedule!.hours.isEmpty) return false;

              var now = DateTime.now();
              return restaurant.schedule!.hours.any((hours) {
                return hours.start != null &&
                    hours.end != null &&
                    hours.start!.isBefore(now) &&
                    hours.end!.isAfter(now);
              });
            }).toList();
          });
          break;
        case TimeFilter.anytime:
          setState(() {
            displayedRestaurants = widget.restaurants ?? <Restaurant>[];
          });
          break;
        default:
      }
    }

    var listTiles = [
      const SizedBox(height: 10.0),
      RestaurantFilters(
        onTimeFilter: handleTimeFilter,
      ),
      ...displayedRestaurants.map((restaurant) {
        return RestaurantTile(restaurant: restaurant);
      }).toList(),
      const SizedBox(height: 10.0),
    ];

    return ListView(children: listTiles);
  }
}
