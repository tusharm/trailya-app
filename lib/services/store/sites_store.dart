import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trailya/services/store/site.dart';

class SitesStore {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Site>> getSites() {
    return Stream.value([
      Site(
        id: '1',
        suburb: 'Melbourne',
        name: 'KMart Melbourne CBD',
        address: '236, Bourke Street',
        state: 'Victoria',
        postcode: '3000',
        exposureDate: '2021-06-13',
        exposureStartTime: '2:40pm',
        exposureEndTime: '3:30pm'
      ),
      Site(
          id: '2',
          suburb: 'Southbank',
          name: 'Chemist Warehouse Southbank',
          address: 'Shops 2 and 3, 153 to 159 Sturt Street',
          state: 'Victoria',
          postcode: '3006',
          exposureDate: '2021-06-06',
          exposureStartTime: '10:00am',
          exposureEndTime: '10:10am'
      ),
    ]);
  }
}