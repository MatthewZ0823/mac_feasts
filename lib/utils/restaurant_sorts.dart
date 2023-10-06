import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_filters.dart';
import 'package:mac_feasts/components/restaurant/restaurant_list.dart';

List<Restaurant> filterRestaurants(
    List<Restaurant>? restaurants, TimeFilter? filter) {
  if (restaurants == null) return <Restaurant>[];

  switch (filter) {
    case TimeFilter.now:
      return restaurants.where((restaurant) {
        return restaurant.isOpen(DateTime.now());
      }).toList();
    case TimeFilter.anytime:
      return restaurants;
    default:
      throw UnimplementedError(
          'Time Filter $filter has not yet been implemented');
  }
}

List<Restaurant> sortRestaurants(
    List<Restaurant> restaurants, SortBy? sortType) {
  switch (sortType) {
    case SortBy.nameAZ:
      return restaurants.toList()..sort((a, b) => a.name.compareTo(b.name));
    case SortBy.nameZA:
      return restaurants.toList()..sort((a, b) => b.name.compareTo(a.name));
    case SortBy.location:
      return _locationSort(restaurants);
    default:
      throw UnimplementedError('Sort $sortType has not yet been implemented');
  }
}

List<Restaurant> _locationSort(List<Restaurant> restaurants) {
  var alphabeticalSort = restaurants.toList()
    ..sort((a, b) {
      if (a.location == null) return 1;
      if (b.location == null) return 1;

      var locationA = a.location ?? '';
      var locationB = b.location ?? '';

      if (locationA.compareTo(locationB) == 0) {
        return a.name.compareTo(b.name);
      }

      return locationA.compareTo(locationB);
    });

  // Move all the off campus locations to the end
  var offCampus = restaurants.where((restaurant) => _isOffCampus(restaurant));
  alphabeticalSort.removeWhere((restaurant) => _isOffCampus(restaurant));
  alphabeticalSort.addAll(offCampus);

  return alphabeticalSort;
}

bool _isOffCampus(Restaurant restaurant) {
  if (restaurant.location == null) return false;
  return restaurant.location!.toLowerCase().trim() == 'off campus';
}
