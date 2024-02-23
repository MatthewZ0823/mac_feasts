/// Get the start of the week for day [date]
///
/// The start of the week is considered to be Monday, at midnight
DateTime getWeekStart(DateTime date) =>
    DateTime(date.year, date.month, date.day - (date.weekday - 1));

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
