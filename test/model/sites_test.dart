import 'package:flutter_test/flutter_test.dart';
import 'package:trailya/model/site.dart';

void main() {
  test('Site.uniqueId', () {
    final aTime = DateTime(2021, 6, 28, 10, 50);

    final site = Site(
      suburb: 'Sydney',
      address: '201 (B), Elizabeth Str',
      title: 'Beans',
      addedTime: aTime,
      exposureEndTime: aTime.subtract(Duration(hours: 1)),
      exposureStartTime: aTime.subtract(Duration(hours: 2)),
      state: 'NSW',
      longitude: null,
      latitude: null,
    );

    expect(
        site.uniqueId,
        equals(
            '201__B___Elizabeth_Str_${aTime.millisecondsSinceEpoch}_${site.start.millisecondsSinceEpoch}_${site.end.millisecondsSinceEpoch}'));
  });
}
