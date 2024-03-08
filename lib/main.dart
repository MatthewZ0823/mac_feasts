import 'package:flutter/material.dart';
import 'package:mac_feasts/components/restaurant/restaurant_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mac Feasts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Mac Feasts'),
            bottom: const TabBar(tabs: [
              Tab(text: 'Restaurants'),
              Tab(text: 'Nutrition'),
            ]),
          ),
          body: const TabBarView(
            children: [
              RestaurantsTab(),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}

class RestaurantsTab extends StatefulWidget {
  const RestaurantsTab({super.key});

  @override
  State<RestaurantsTab> createState() => _RestaurantsTabState();
}

class _RestaurantsTabState extends State<RestaurantsTab> {
  @override
  void initState() {
    super.initState();
  }

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
