import 'package:flutter_test/flutter_test.dart';
import 'package:google_place/google_place.dart' as places;

void main() {
  test('String.split() splits the string on the delimiter', () {
    var string = 'foo,bar,baz';
    expect(string.split(','), equals(['foo', 'bar', 'baz']));
  });

  test('String.trim() removes surrounding whitespace', () {
    var string = '  foo ';
    expect(string.trim(), equals('foo'));
  });

  test('location equality', () {
    final a = places.Location(lat: -33.7136, lng: 151.1476);
    final b = places.Location(lat: -33.7136, lng: 151.1476);
    expect(a, equals(b));
  });
}
