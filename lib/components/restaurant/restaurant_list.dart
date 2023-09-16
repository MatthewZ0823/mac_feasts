import 'package:flutter/material.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_tile.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    super.key,
    required this.restaurants,
  });

  final List<Restaurant>? restaurants;

  @override
  Widget build(BuildContext context) {
    if (restaurants == null || restaurants!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    var listTiles = [
      const SizedBox(height: 10.0),
      ...restaurants!.map((restaurant) {
        return RestaurantTile(restaurant: restaurant);
      }).toList(),
      const SizedBox(height: 10.0),
    ];

    return ListView(children: listTiles);
  }
}
