import 'package:mac_feasts/api/schedule.dart';

class Restaurant {
  final String name;
  final String location;
  final Schedule? schedule;

  Restaurant(this.name, this.location, this.schedule);

  /// Checks if this restaurant is open at [time]
  bool isOpen(DateTime time) {
    if (schedule == null || schedule!.openingTimes.isEmpty) return false;

    return schedule!.openingTimes.any((hours) {
      return hours.start != null &&
          hours.end != null &&
          hours.start!.isBefore(time) &&
          hours.end!.isAfter(time);
    });
  }

  @override
  String toString() {
    return 'Name: $name, Location: $location, Schedule: $schedule';
  }
}
