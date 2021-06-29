import 'dart:math';

import 'package:location/location.dart';

class Visit {
  Visit(this.loc, {int? id}) {
    _id = id ?? random.nextInt(1 << 30);
    _startTime = loc.time!;
  }

  static final Random random = Random();
  static const int trackingMinStaySec = 60;

  final LocationData loc;
  late final double _startTime;
  late final int _id;
  double? _endTime;

  String get uniqueId => _id.toString();

  DateTime get start => DateTime.fromMillisecondsSinceEpoch(_startTime.toInt());

  DateTime get end => DateTime.fromMillisecondsSinceEpoch(_endTime!.toInt());

  void finish({int? msSinceEpoch}) {
    final time = (msSinceEpoch == null)
        ? DateTime.now().millisecondsSinceEpoch
        : msSinceEpoch;
    _endTime = time.toDouble();
  }

  // Used to restore from local datastore
  static Visit fromMap(Map<String, double> data) {
    final location = LocationData.fromMap(data);

    final visit = Visit(location, id: data['id']!.toInt());
    visit.finish(msSinceEpoch: data['end_time']!.toInt());

    return visit;
  }

  Map<String, double?> toMap() => {
        'id': _id.toDouble(),
        'latitude': loc.latitude,
        'longitude': loc.longitude,
        'accuracy': loc.accuracy,
        'altitude': loc.altitude,
        'speed': loc.speed,
        'speed_accuracy': loc.speedAccuracy,
        'heading': loc.heading,
        'time': loc.time,
        'end_time': _endTime
      };

  bool longEnoughSince(Visit other) {
    DateTime asDateTime(double millisSinceEpoch) =>
        DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch.toInt());

    final delta =
        asDateTime(_startTime).difference(asDateTime(other._startTime));
    return delta.inSeconds > trackingMinStaySec;
  }

  @override
  String toString() {
    return """
    Location Data:
      lat/lng: ${loc.latitude}/${loc.longitude}
      startTime: ${DateTime.fromMillisecondsSinceEpoch(_startTime.toInt())}
      endTime: ${(_endTime == null) ? '' : DateTime.fromMillisecondsSinceEpoch(_endTime!.toInt())}
    """;
  }
}
