import 'package:google_place/google_place.dart' as places;
import 'package:location/location.dart';

class Visit {
  final LocationData loc;
  final places.SearchResult nearby;
  final double startTime;
  double? endTime;

  Visit(this.loc, this.nearby) : this.startTime = loc.time!;

  void end() {
    endTime = DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  bool samePlaceId(Visit other) {
    return this.nearby.placeId == other.nearby.placeId;
  }

  @override
  String toString() {
    return """
    Location Data:
      lat/lng: ${loc.latitude}/${loc.longitude}
    Place:
      placeId: ${nearby.placeId}
      name: ${nearby.name}
      startTime: ${DateTime.fromMillisecondsSinceEpoch(startTime.toInt())}
      endTime: ${(endTime == null) ? '' : DateTime.fromMillisecondsSinceEpoch(endTime!.toInt())}
    """;
  }
}
