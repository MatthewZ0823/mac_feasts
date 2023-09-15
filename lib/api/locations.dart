import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class Location {
  final String name;
  final Uri url;

  Location(this.name, this.url);

  /// Searches [div] and creates a location if found
  factory Location.fromLocationDiv(Element div) {
    var linkEl = div.querySelector('a');

    if (linkEl == null) throw Exception("Could not parse location from div");

    var href = linkEl.attributes['href'];
    if (href != null && href.contains('/locations/')) {
      return Location(linkEl.innerHtml, Uri.https("maceats.mcmaster.ca", href));
    }

    throw Exception("Could not parse location from div");
  }

  Future<Document> getDocument() async {
    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch from MacEats');
    }

    return html_parser.parse(response.body);
  }

  @override
  String toString() {
    return name;
  }

  /// Gets all the locations in [document]. [document] should come from https://maceats.mcmaster.ca/locations
  static List<Location> getLocationsFromDocument(Document document) {
    var locationDivs = document.querySelectorAll('.unit');

    return locationDivs
        .map((locationDiv) => Location.fromLocationDiv(locationDiv))
        .toList();
  }
}
