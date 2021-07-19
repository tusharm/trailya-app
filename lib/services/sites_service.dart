import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mock_data/mock_data.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/user_config.dart';

class SitesService {
  static const trackingPeriod = 15;

  final _firestore = FirebaseFirestore.instance;

  Stream<List<Site>> getSites(String location) {
    return _firestore
        .collectionGroup('${location}_sites')
        .where('exposure_start_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()
                .subtract(Duration(days: trackingPeriod))
                .toUtc()))
        .snapshots()
        .map((snapshot) {
      final sites = snapshot.docs.map((e) => Site.fromMap(e.data())).toList();
      sites.sort((a, b) => b.addedTime.compareTo(a.addedTime));
      return sites;
    });
  }
}

///
/// Stub implementation of SitesService to generate random sites regularly
///
class SitesServiceStub extends SitesService {
  List<Site> sites = List.empty(growable: true);
  final business = [
    'Foods',
    'Liquor',
    'Seafood',
    'Shopping Mall',
    'Clinic',
    'Station',
    'Cinema Hall',
  ];

  @override
  Stream<List<Site>> getSites(String location) {
    return _sites();
  }

  Stream<List<Site>> _sites() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 10));

      final latlng = mockLocation(
          Location.NSW.latlng.latitude, Location.NSW.latlng.longitude, 100000);
      final startTime = DateTime.now().subtract(Duration(days: 3, hours: 5));
      final endTime = startTime.add(Duration(hours: 5));

      sites.add(Site(
        title: '${mockName()} ${business[mockInteger(0, business.length - 1)]}',
        addedTime: DateTime.now(),
        exposureEndTime: endTime,
        exposureStartTime: startTime,
        suburb: mockName(),
        state: 'NSW',
        address: '${mockInteger(1, 100)} ${mockName()} Ave',
        longitude: latlng['lon'],
        latitude: latlng['lat'],
        postcode: mockInteger(2000, 2100),
      ));

      yield sites;
    }
  }
}
