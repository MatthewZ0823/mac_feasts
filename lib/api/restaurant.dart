import 'package:mac_feasts/api/schedule.dart';
import 'package:mac_feasts/utils/dates.dart';

class Restaurant {
  final String name;
  final String location;
  final Schedule schedule;

  Restaurant(this.name, this.location, this.schedule);

  /// Checks if this restaurant is open at [time]
  bool isOpen(DateTime time) {
    if (schedule.openingTimes.isEmpty) return false;

    return schedule.openingTimes.any((hours) {
      return hours.start.isBefore(time) && hours.end.isAfter(time);
    });
  }

  Schedule scheduleFromWeek(DateTime week) {
    var weekStart = getWeekStart(week);

    return Schedule(schedule.openingTimes.where((openingTime) {
      int differenceInDays = openingTime.start.difference(weekStart).inDays;

      return differenceInDays < 7;
    }).toList());
  }

  @override
  String toString() {
    return 'Name: $name, Location: $location, Schedule: $schedule';
  }
}
