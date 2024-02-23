/// Get the start of the week for day [date]
///
/// The start of the week is considered to be Monday, at midnight
DateTime getWeekStart(DateTime date) =>
    DateTime(date.year, date.month, date.day - (date.weekday - 1));

extension DateCompare on DateTime {
  /// Checks if [other] is the same day as this [DateTime], by comparing only the date
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if [other] is before or equal to as this [DateTime]
  bool isBeforeOrEqual(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  /// Checks if [other] is after or equal to as this [DateTime]
  bool isAfterOrEqual(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }
}
