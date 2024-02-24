import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mac_feasts/api/eats.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_filters.dart';
import 'package:mac_feasts/components/restaurant/restaurant_tile.dart';
import 'package:mac_feasts/utils/constants.dart';
import 'package:mac_feasts/utils/dates.dart';
import 'package:mac_feasts/utils/restaurant_sorts.dart';

enum TimeFilter { now, anytime }

class RestaurantList extends StatefulWidget {
  const RestaurantList({
    super.key,
    required this.restaurants,
  });

  final UnmodifiableListView<Restaurant>? restaurants;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  var displayedRestaurants = <Restaurant>[];
  var activeTimeFilter = defaultTimeFilter;
  var activeSort = defaultSort;

  // Week starts on a Monday
  DateTime weekStart = getWeekStart(DateTime.now());

  void handleTimeFilterSelected(TimeFilter? selectedFilter) {
    setState(() {
      activeTimeFilter = selectedFilter ?? defaultTimeFilter;
      displayedRestaurants = sortRestaurants(
        filterRestaurants(widget.restaurants, activeTimeFilter),
        activeSort,
      );
    });
  }

  void handleSortSelected(SortBy selectedSort) {
    setState(() {
      activeSort = selectedSort;
      displayedRestaurants = sortRestaurants(
        filterRestaurants(widget.restaurants, activeTimeFilter),
        activeSort,
      );
    });
  }

  @override
  void didUpdateWidget(covariant RestaurantList oldWidget) {
    handleTimeFilterSelected(activeTimeFilter);
    handleSortSelected(activeSort);
    super.didUpdateWidget(oldWidget);
  }

  /// Change [weekStart] by [numWeeks]
  void changeWeekStart(int numWeeks) {
    setState(() {
      weekStart = weekStart.add(Duration(days: 7 * numWeeks));

      if (widget.restaurants == null) return;

      // if (widget.restaurants!
      //     .any((restaurant) => !restaurant.isScrapedWeek(weekStart))) {
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.restaurants == null || widget.restaurants!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    var listTiles = [
      const SizedBox(height: 10.0),
      RestaurantFilters(
        onTimeFilterSelected: (selectedFilter) =>
            handleTimeFilterSelected(selectedFilter),
        onSortSelected: (sortType) => handleSortSelected(sortType),
      ),
      ...displayedRestaurants.map((restaurant) {
        return RestaurantTile(
          restaurant: restaurant,
          weekStart: weekStart,
          handlePrevWeek: () {
            changeWeekStart(-1);
          },
          handleNextWeek: () {
            changeWeekStart(1);
          },
        );
      }),
      const SizedBox(height: 10.0),
    ];

    return ListView(children: listTiles);
  }
}
