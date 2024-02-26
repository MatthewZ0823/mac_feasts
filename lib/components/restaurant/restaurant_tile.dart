import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_schedule.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
    required this.weekStart,
    required this.handlePrevWeek,
    required this.handleNextWeek,
    required this.handleFavorite,
  });

  final Restaurant restaurant;
  final DateTime weekStart;
  final void Function() handlePrevWeek;
  final void Function() handleNextWeek;
  final void Function() handleFavorite;

  static final DateFormat _dateFormatter = DateFormat('EEEE MMM dd');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    final locationStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
      fontStyle: FontStyle.italic,
    );

    String location = restaurant.location;

    String weekStartStr = _dateFormatter.format(weekStart);
    String weekEndStr =
        _dateFormatter.format(weekStart.add(const Duration(days: 6)));

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          border: Border.all(
            color: theme.cardColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    restaurant.name,
                    style: titleStyle,
                  ),
                ),
                FavoriteButton(
                  favorited: restaurant.favorited,
                  onPressed: handleFavorite,
                ),
              ],
            ),
            if (location != '')
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  location,
                  style: locationStyle,
                ),
              ),
            Row(
              children: [
                IconButton(
                  onPressed: handlePrevWeek,
                  icon: const Icon(Icons.arrow_left),
                ),
                Expanded(
                  child: Text(
                    '$weekStartStr - $weekEndStr',
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: handleNextWeek,
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
            RestaurantSchedule(
              schedule: restaurant.scheduleFromWeek(weekStart),
              loaded: restaurant.isScrapedWeek(weekStart),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.favorited,
    required this.onPressed,
  });

  final bool favorited;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: favorited ? const Icon(Icons.star) : const Icon(Icons.star_border),
      onPressed: onPressed,
      color: favorited ? Colors.amber : Theme.of(context).iconTheme.color,
    );
  }
}
