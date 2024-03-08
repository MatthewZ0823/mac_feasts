import 'package:flutter/material.dart';
import 'package:mac_feasts/api/eats.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_filters.dart';
import 'package:mac_feasts/components/restaurant/restaurant_tile.dart';
import 'package:mac_feasts/utils/constants.dart';
import 'package:mac_feasts/utils/dates.dart';
import 'package:mac_feasts/utils/restaurant_sorts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<Restaurant>> initRestaurants() async {
    // Start all the async calls
    var prefsFuture = SharedPreferences.getInstance();
    var restaurantsFuture = getAllRestaurants(DateTime.now());

    // Wait for them to finish
    var prefs = await prefsFuture;
    var restaurants = await restaurantsFuture;

    var favorited = prefs.getStringList(favoritesKeys);

    if (favorited == null) return restaurants;
    for (final restaurant in restaurants) {
      restaurant.favorited = favorited.contains(restaurant.name);
    }

    return restaurants;
  }

  @override
  void initState() {
    super.initState();
    restaurants = initRestaurants();
  }

  var activeTimeFilter = defaultTimeFilter;
  var activeSort = defaultSort;

  // Week starts on a Monday
  DateTime weekStart = getWeekStart(DateTime.now());

  void handleTimeFilterSelected(TimeFilter? selectedFilter) async {
    setState(() {
      activeTimeFilter = selectedFilter ?? defaultTimeFilter;

      // Set the week to the current week if the time filter is set to now
      if (activeTimeFilter == TimeFilter.now) {
        weekStart = getWeekStart(DateTime.now());
      }
    });
  }

  void handleSortSelected(SortBy selectedSort) async {
    setState(() {
      activeSort = selectedSort;
    });
  }

  void handleFavorite(Restaurant restaurant) async {
    setState(() {
      restaurant.toggleFavorite();
    });

    // Write the favorites to disk
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        favoritesKeys,
        (await restaurants)
            .where((restaurant) => restaurant.favorited)
            .map((restaurant) => restaurant.name)
            .toList());
  }

  List<Restaurant> getDisplayedRestaurants(List<Restaurant> restaurants) {
    var sorted = sortRestaurants(restaurants, activeSort);
    return filterRestaurants(sorted, activeTimeFilter);
  }

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
                    handleFavorite: () => handleFavorite(restaurant),
                  );
                }),
              ],
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 30,
              child: Center(
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
