import 'dart:math';

import 'package:location/location.dart';
import 'package:trailya/model/place.dart';
import 'package:trailya/utils/date_util.dart';

class Visit extends Place {
  Visit({
    required this.loc,
    required DateTime start,
    required DateTime end,
    int? id,
  }) : super(
          lat: loc.latitude,
          lng: loc.longitude,
          start: start,
          end: end,
        ) {
    _id = id ?? random.nextInt(1 << 30);
  }

  static final Random random = Random();
  final LocationData loc;

  late final int _id;

  String get id => _id.toString();

  int _exposed = 0;

  bool get exposed => _exposed == 1;

  set exposed(bool exposed) {
    _exposed = exposed ? 1 : 0;
  }

  // Used to restore from local datastore
  static Visit fromMap(Map<String, dynamic> data) {
    final location = LocationData.fromMap(data);

    final visit = Visit(
      loc: location,
      start: asDateTime(data['time'].toInt()),
      end: asDateTime(data['end_time'].toInt()),
      id: data['id'].toInt(),
    );
    visit._exposed = data['exposed'].toInt();
    return visit;
  }

  Map<String, dynamic> toMap() => {
        'id': _id.toDouble(),
        'latitude': loc.latitude,
        'longitude': loc.longitude,
        'accuracy': loc.accuracy,
        'altitude': loc.altitude,
        'speed': loc.speed,
        'speed_accuracy': loc.speedAccuracy,
        'heading': loc.heading,
        'time': start.millisecondsSinceEpoch,
        'end_time': end.millisecondsSinceEpoch,
        'exposed': _exposed,
      };

  @override
  String toString() {
    return '''
    Location Data:
      lat/lng: ${loc.latitude}/${loc.longitude}
      exposed: $exposed
      startTime: $start
      endTime: $end
    ''';
  }
}
