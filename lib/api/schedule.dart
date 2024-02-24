import 'package:mac_feasts/api/opening_time.dart';
import 'package:mac_feasts/utils/constants.dart';

class Schedule {
  // List of opening and closing hours for a restaurant
  final List<OpeningTime> openingTimes;

  /// List of weeks that have been scraped from the web
  ///
  /// The DateTime represents the start of the week (Monday)
  final List<DateTime> scrapedWeeks;

  Schedule(this.openingTimes, this.scrapedWeeks);
  Schedule.empty()
      : openingTimes = [],
        scrapedWeeks = [];

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

  @override
  String toString() {
    return openingTimes.toString();
  }
}
