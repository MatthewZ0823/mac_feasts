import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:mac_feasts/utils/constants.dart';

class Hours {
  final DateTime? start;
  final DateTime? end;

  Hours(this.start, this.end);

  /// Puts the start and end times into a nice format for the UI
  String toPrettyString(BuildContext context) {
    if (start == null || end == null) return "Closed";

    var $start = start ?? DateTime.now();
    var $end = end ?? DateTime.now();

    var startTime = TimeOfDay.fromDateTime($start);
    var endTime = TimeOfDay.fromDateTime($end);

    return "${startTime.format(context)} - ${endTime.format(context)}";
  }

  @override
  String toString() {
    return "start: $start, end: $end";
  }
}

class Schedule {
  // List of opening and closing hours for a restaurant
  final List<Hours> hours;

  Schedule(this.hours);
  Schedule.empty() : hours = [];

  /// Searches [div] and creates a location if found
  factory Schedule.fromScheduleDiv(html.Element div) {
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

  Iterable<Hours> getOpeningHours(String dayOfWeek) {
    return hours.where(
      (hours) {
        if (hours.start == null) return false;
        return hours.start!.weekday == daysOfWeek.indexOf(dayOfWeek) + 1;
      },
    );
  }

  static List<Hours> _getHoursFromRow(
      List<html.Element> tableRows, int rowNum) {
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
    return hours.toString();
  }
}
