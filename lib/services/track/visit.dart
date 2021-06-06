import 'package:location/location.dart';

class Visit {
  Visit(this.loc) : startTime = loc.time!;

  static const int trackingMinStaySec = 60;

  final LocationData loc;
  final double startTime;
  double? endTime;

  void end() {
    endTime = DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  bool longEnoughSince(Visit other) {
    DateTime asDateTime(double millisSinceEpoch) =>
        DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch.toInt());

    final delta = asDateTime(startTime).difference(asDateTime(other.startTime));
    return delta.inSeconds > trackingMinStaySec;
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
