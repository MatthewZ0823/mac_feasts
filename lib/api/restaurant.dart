import 'package:mac_feasts/api/schedule.dart';
import 'package:mac_feasts/utils/dates.dart';

class Restaurant {
  final String name;
  final String location;
  final Schedule schedule;
  bool favorited;

  Restaurant(this.name, this.location, this.schedule, {this.favorited = false});

  /// Checks if this restaurant is open at [time]
  bool isOpen(DateTime time) {
    if (schedule.openingTimes.isEmpty) return false;

    return schedule.openingTimes.any((hours) {
      return hours.start.isBefore(time) && hours.end.isAfter(time);
    });
  }

  Schedule scheduleFromWeek(DateTime week) {
    var weekStart = getWeekStart(week);
    var weekEnd = weekStart.add(const Duration(days: 7));

    // Accounting for daylight savings
    if (weekEnd.hour == 23) {
      weekEnd = weekEnd.add(const Duration(hours: 1));
    } else if (weekEnd.hour == 1) {
      weekEnd = weekEnd.add(const Duration(hours: -1));
    }

    var filteredOpeningTimes = schedule.openingTimes.where((openingTime) {
      return openingTime.end.isBefore(weekEnd) &&
          openingTime.start.isAfterOrEqual(weekStart);
    }).toList();

    return Schedule(filteredOpeningTimes, schedule.scrapedWeeks);
  }

  bool isScrapedWeek(DateTime weekStart) {
    return schedule.scrapedWeeks.contains(weekStart);
  }

  void toggleFavorite() {
    favorited = !favorited;
  }

  @override
  String toString() {
    return 'Name: $name, Location: $location, Schedule: $schedule';
  }
}
