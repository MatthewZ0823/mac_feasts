import 'package:flutter/material.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/components/restaurant/restaurant_schedule.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

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

    String location = restaurant.location ?? '';

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
            Text(
              restaurant.name,
              style: titleStyle,
            ),
            if (location != '')
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  location,
                  style: locationStyle,
                ),
              ),
            RestaurantSchedule(schedule: restaurant.schedule),
          ],
        ),
      ),
    );
  }
}
