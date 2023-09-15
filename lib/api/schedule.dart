import 'package:html/dom.dart';

class Hours {
  final DateTime? start;
  final DateTime? end;

  Hours(this.start, this.end);

  @override
  String toString() {
    return "start: $start, end $end";
  }
}

class Schedule {
  final List<Hours> schedule;

  Schedule(this.schedule);

  /// Searches [div] and creates a location if found
  factory Schedule.fromScheduleDiv(Element div) {
    List<Hours> schedule = [];

    var tableRows = div.querySelectorAll('tr');
    if (tableRows.isEmpty) throw Exception("Could not parse schedule from div");

    // First table row doesn't have any useful information
    for (int i = 1; i < tableRows.length; i++) {
      try {
        schedule.addAll(_getHoursFromRow(tableRows, i));
      } on Exception {
        throw Exception("Unknown schedule row format");
      }
    }

    return Schedule(schedule);
  }

  static List<Hours> _getHoursFromRow(List<Element> tableRows, int rowNum) {
    var tableRow = tableRows[rowNum];
    var dayEl = tableRow.querySelector('.day');
    var timeEl = tableRow.querySelector('.time');

    if (dayEl == null || timeEl == null) {
      throw Exception("No date/time found");
    }

    if (timeEl.innerHtml.toLowerCase() == 'closed') {
      return [Hours(null, null)];
    }

    // Bistro opens for multiple periods in one day
    // Ex. 11 am - 3 pm, 4:00 pm - 8:30 pm
    var periods = timeEl.innerHtml.split(',');

    return periods.map((period) {
      var [periodStart, periodEnd] = period
          .replaceAll(' ', '')
          .split('-')
          .map((time) => _parseTime(time, rowNum - 1))
          .toList();

      return Hours(periodStart, periodEnd);
    }).toList();
  }

  /// Returns a DateTime at time [s], [daysFromToday] from today.
  static DateTime _parseTime(String s, int daysFromToday) {
    var am = s.substring(s.length - 2) == 'am';
    var time = s.substring(0, s.length - 2);
    var [hour, minute] = [0, 0];

    if (time.contains(':')) {
      [hour, minute] = time.split(':').map((e) => int.parse(e)).toList();
    } else {
      hour = int.parse(time);
    }

    var now = DateTime.now().toLocal();
    var midnightToday = DateTime(now.year, now.month, now.day);
    var timeToAdd = Duration(days: daysFromToday, minutes: minute);

    if (am && hour == 12) {
      timeToAdd += Duration(hours: hour - 12);
    } else if (!am && hour != 12) {
      timeToAdd += Duration(hours: hour + 12);
    } else {
      timeToAdd += Duration(hours: hour);
    }

    return midnightToday.add(timeToAdd);
  }

  @override
  String toString() {
    return schedule.toString();
  }
}
