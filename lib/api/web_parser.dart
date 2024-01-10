import 'package:html/dom.dart' as html;
import 'package:mac_feasts/api/opening_time.dart';
import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/api/schedule.dart';

class ParseException implements Exception {
  final String message;

  ParseException(this.message);

  @override
  String toString() => 'ParseException: $message';
}

/// Returns a DateTime at time [s], [daysFromToday] from today.
///
/// Where [s] is a string formatted like 1:32am
DateTime _parseTime(String s, int daysFromToday) {
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

/// Returns a Schedule object with the opening times contained in [row]
///
/// [row] should be an HTML tr element, with >1 td child tags
/// The 0th td should contain the name of the Restaurant
/// And the following td elements should contain the opening times
/// of the restaurant at the different days of the week
/// The 1st td should correspond to Monday, 2nd Tuesday, etc.
Schedule _scheduleFromTableRow(html.Element row) {
  var tableEls = row.querySelectorAll('td');

  var times = <OpeningTime>[];

  for (var i = 1; i < tableEls.length; i++) {
    var unparsedTimes = tableEls[i].querySelector('span')?.innerHtml;
    if (unparsedTimes == null) continue;
    if (unparsedTimes == 'Closed') continue;

    var timeStrings =
        unparsedTimes.split('<br>').map((str) => str.trim()).toList();

    timeStrings.removeWhere((element) => element.isEmpty);

    times += timeStrings.map((timeStr) {
      var daysFromToday = DateTime.now().weekday - i;
      var [openingTime, closingTime] = timeStr
          .split('–')
          .map((str) => str.trim())
          .map((str) => _parseTime(str, daysFromToday))
          .toList();

      return OpeningTime(openingTime, closingTime);
    }).toList();
  }

  return Schedule(times);
}

/// Returns a [Restaurant] object, using on the contents of [row]
///
/// [row] should be an HTML tr element, with >1 td child tags
/// The 0th td should contain the name of the Restaurant
/// And the following td elements should contain the opening times
/// of the restaurant at the different days of the week
/// The 1st td should correspond to Monday, 2nd Tuesday, etc.
///
/// Throws a [ParseException] if [row] could not be parsed
Restaurant restaurantFromTableRow(html.Element row) {
  String name, location;

  var firstDataCell = row.querySelector('td');
  if (firstDataCell == null) {
    throw ParseException('Table row could not be parsed');
  }

  var firstInnerHtml = firstDataCell.innerHtml.trim();

  // There are a few exceptions to the general rule of name (location).
  // These exceptions have been hard coded in
  if (firstInnerHtml == 'Bistro @ MKR') {
    name = 'Bistro';
    location = 'MKR';
  } else if (firstInnerHtml == 'Café on Bay') {
    name = 'Café on Bay';
    location = 'David Braley Health Sciences Centre';
  } else if (firstInnerHtml == 'IAHS Café') {
    name = 'IAHS Café';
    location = 'Institute for Applied Health Sciences';
  } else {
    [name, location] =
        firstInnerHtml.split('(').map((str) => str.trim()).toList();

    // Remove the ')' at the end of the string
    location = location.substring(0, location.length - 1);
  }

  var schedule = _scheduleFromTableRow(row);

  return Restaurant(name, location, schedule);
}
