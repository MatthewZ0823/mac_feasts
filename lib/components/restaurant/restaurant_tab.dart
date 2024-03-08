import 'package:flutter/material.dart';
import 'restaurant_list.dart';

class RestaurantsTab extends StatelessWidget {
  const RestaurantsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RestaurantList(),
          ),
        ],
      ),
    );
  }
}
