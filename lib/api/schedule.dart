import 'package:mac_feasts/api/opening_time.dart';
import 'package:mac_feasts/utils/constants.dart';
import 'package:mac_feasts/utils/dates.dart';

class Schedule {
  // List of opening and closing hours for a restaurant
  final List<OpeningTime> openingTimes;

  Schedule(this.openingTimes);
  Schedule.empty() : openingTimes = [];

  /// Gets the opening hours on day [dayOfWeek]
  ///
  /// [dayOfWeek] is a string representing the day of the week. For example Wednesday
  Iterable<OpeningTime> getOpeningHours(String dayOfWeek) {
    return openingTimes.where(
      (hours) {
        return hours.start.weekday == daysOfWeek.indexOf(dayOfWeek) + 1;
      },
    );
  }

  /// Gets the opening hours on day [date]
  Iterable<OpeningTime> getOpeningHoursFromDate(DateTime date) {
    return openingTimes.where(
      (hours) {
        return hours.start.isSameDate(date);
      },
    );
  }

  @override
  String toString() {
    return openingTimes.toString();
  }
}
