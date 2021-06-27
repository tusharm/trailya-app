import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trailya/model/site.dart';

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
