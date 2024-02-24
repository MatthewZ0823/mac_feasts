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
  });

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  late Future<List<Restaurant>> restaurants;

  @override
  void initState() {
    super.initState();
    restaurants = getAllRestaurants(DateTime.now());
  }

  // var displayedRestaurants = <Restaurant>[];
  var activeTimeFilter = defaultTimeFilter;
  var activeSort = defaultSort;

  // Week starts on a Monday
  DateTime weekStart = getWeekStart(DateTime.now());

  void handleTimeFilterSelected(TimeFilter? selectedFilter) async {
    // var $restaurants = await restaurants;
    //
    setState(() {
      activeTimeFilter = selectedFilter ?? defaultTimeFilter;
      // displayedRestaurants = sortRestaurants(
      //   filterRestaurants($restaurants, activeTimeFilter),
      //   activeSort,
      // );
    });
  }

  void handleSortSelected(SortBy selectedSort) async {
    // var $restaurants = await restaurants;
    //
    setState(() {
      activeSort = selectedSort;
      // displayedRestaurants = sortRestaurants(
      //   filterRestaurants($restaurants, activeTimeFilter),
      //   activeSort,
      // );
    });
  }

  List<Restaurant> getDisplayedRestaurants(List<Restaurant> restaurants) {
    var sorted = sortRestaurants(restaurants, activeSort);
    return filterRestaurants(sorted, activeTimeFilter);
  }

  // @override
  // void didUpdateWidget(covariant RestaurantList oldWidget) {
  //   handleTimeFilterSelected(activeTimeFilter);
  //   handleSortSelected(activeSort);
  //   super.didUpdateWidget(oldWidget);
  // }

  /// Change [weekStart] by [numWeeks]
  void changeWeekStart(int numWeeks) async {
    var $restaurants = await restaurants;

    setState(() {
      weekStart = weekStart.add(Duration(days: 7 * numWeeks));

      if ($restaurants
          .any((restaurant) => !restaurant.isScrapedWeek(weekStart))) {
        restaurants = updateRestaurantSchedules($restaurants, weekStart);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var listTiles = [
      const SizedBox(height: 10.0),
      RestaurantFilters(
        onTimeFilterSelected: (selectedFilter) =>
            handleTimeFilterSelected(selectedFilter),
        onSortSelected: (sortType) => handleSortSelected(sortType),
      ),
      const SizedBox(height: 10.0),
      FutureBuilder(
        future: restaurants,
        builder:
            (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;

            if (data == null) return const SizedBox.shrink();
            return Column(
              children: [
                ...getDisplayedRestaurants(data).map((restaurant) {
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
              ],
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 30,
              child: Center(
                // child: SizedBox(
                //   height: 30,
                //   width: 30,
                //   child: Icon(Icons.error),
                // ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.error),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      TextSpan(text: ' Error fetching data from Maceats'),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox(
              height: 30,
              child: Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      ),
      const SizedBox(height: 10.0),
    ];

    return ListView(children: listTiles);
  }
}
