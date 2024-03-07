import 'package:flutter/material.dart';
import 'package:mac_feasts/api/schedule.dart';
import 'package:mac_feasts/utils/constants.dart';

class RestaurantSchedule extends StatelessWidget {
  const RestaurantSchedule({
    super.key,
    required this.schedule,
    required this.loaded,
    required this.isCurrentWeek,
  });

  final Schedule? schedule;
  final bool loaded;
  final bool isCurrentWeek;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Make schedule a local varaible to promote it later
    var $schedule = schedule;

    if ($schedule == null) {
      return const SizedBox(
        height: 2.0,
      );
    }

    Map<String, String> scheduleMap = pairWeekdayWithHours($schedule, context);

    var tableChildren = <TableRow>[];
    scheduleMap.forEach((weekday, openingTime) {
      String openingStatus;
      bool shouldBold =
          isCurrentWeek && daysOfWeek[DateTime.now().weekday - 1] == weekday;

      if (!loaded) {
        openingStatus = 'Loading...';
      } else if (openingTime == '') {
        openingStatus = 'Closed';
      } else {
        openingStatus = openingTime;
      }

      tableChildren.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Text(
              weekday,
              style: TextStyle(
                fontWeight: shouldBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Text(
              openingStatus,
              style: TextStyle(
                fontWeight: shouldBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ));
    });

    return Column(
      children: [
        const SizedBox(height: 10.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            color: theme.primaryColorLight,
            border: Border.all(width: 1),
          ),
          child: Column(
            children: [
              Table(
                border: TableBorder.symmetric(
                  inside:
                      BorderSide(width: 1, color: theme.colorScheme.outline),
                ),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                },
                children: tableChildren,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }

  /// Pairs each schedule list entry with its corresponding weekday
  Map<String, String> pairWeekdayWithHours(
      Schedule $schedule, BuildContext context) {
    var openingTimes = daysOfWeek.map((weekday) {
      return $schedule
          .getOpeningHours(weekday)
          .map((hours) => hours.toPrettyString(context))
          .join('\n');
    });
    Map<String, String> scheduleMap =
        Map.fromIterables(daysOfWeek, openingTimes);
    return scheduleMap;
  }
}
