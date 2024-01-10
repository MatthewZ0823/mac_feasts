import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
// import 'dart:developer' as developer;

import 'package:mac_feasts/api/restaurant.dart';
import 'package:mac_feasts/api/web_parser.dart';

Future<String> fetchCalendar(DateTime date) async {
  var formattedDate = DateFormat('yyyy-MM-dd').format(date);
  var response = await http.get(Uri.https('hospitality-mcmaster.libcal.com',
      '/widget/hours/grid', {'date': formattedDate}));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to fetch from MacEats');
  }
}

Future<List<Restaurant>> getAllRestaurants() async {
  var restaurants = <Restaurant>[];
  var input = await fetchCalendar(DateTime.now());
  var document = html_parser.parse(input);

  var rows = document.querySelectorAll('tr.s-lc-whw-loc');

  for (final row in rows) {
    restaurants.add(restaurantFromTableRow(row));
  }

  return restaurants;
}
