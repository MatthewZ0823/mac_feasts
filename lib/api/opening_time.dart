import 'package:flutter/material.dart';

class OpeningTime {
  final DateTime? start;
  final DateTime? end;

  OpeningTime(this.start, this.end);

  /// Puts the start and end times into a nice format for the UI
  String toPrettyString(BuildContext context) {
    if (start == null || end == null) return 'Closed';

    var $start = start ?? DateTime.now();
    var $end = end ?? DateTime.now();

    var startTime = TimeOfDay.fromDateTime($start);
    var endTime = TimeOfDay.fromDateTime($end);

    return '${startTime.format(context)} - ${endTime.format(context)}';
  }

  @override
  String toString() {
    return 'start: $start, end: $end';
  }
}
