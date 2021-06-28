import 'package:location/location.dart';

class Visit {
  Visit(this.loc) : _startTime = loc.time!;

  static const int trackingMinStaySec = 60;

  final LocationData loc;
  final double _startTime;
  double? _endTime;

  String get uniqueId => '${loc.latitude}_${loc.longitude}_${loc.time}';

  DateTime get start => DateTime.fromMillisecondsSinceEpoch(_startTime.toInt());
  DateTime get end => DateTime.fromMillisecondsSinceEpoch(_endTime!.toInt());

  void finish() => _endTime = DateTime.now().millisecondsSinceEpoch.toDouble();

  bool longEnoughSince(Visit other) {
    DateTime asDateTime(double millisSinceEpoch) =>
        DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch.toInt());

    final delta =
        asDateTime(_startTime).difference(asDateTime(other._startTime));
    return delta.inSeconds > trackingMinStaySec;
  }

  Duration duration() {
    // TODO: shouldn't be called before endTime is set
    final delta = _endTime!.toInt() - _startTime.toInt();
    return Duration(milliseconds: delta);
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
