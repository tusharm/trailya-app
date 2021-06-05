import 'package:location/location.dart';

class Visit {
  static const int TRACKING_MIN_STAY_SEC = 15;

  final LocationData loc;
  final double startTime;
  double? endTime;

  Visit(this.loc) : this.startTime = loc.time!;

  void end() {
    endTime = DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  bool longEnoughSince(Visit other) {
    DateTime asDateTime(double millisSinceEpoch) =>
        DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch.toInt());

    final delta =
        asDateTime(this.startTime).difference(asDateTime(other.startTime));
    return delta.inSeconds > TRACKING_MIN_STAY_SEC;
  }

  Duration duration() {
    // TODO: shouldn't be called before endTime is set
    final delta = endTime!.toInt() - startTime.toInt();
    return Duration(milliseconds: delta);
  }

  @override
  String toString() {
    return """
    Location Data:
      lat/lng: ${loc.latitude}/${loc.longitude}
      startTime: ${DateTime.fromMillisecondsSinceEpoch(startTime.toInt())}
      endTime: ${(endTime == null) ? '' : DateTime.fromMillisecondsSinceEpoch(endTime!.toInt())}
    """;
  }
}
