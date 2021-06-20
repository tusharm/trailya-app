

class Site {
  Site({
    required this.title,
    required this.suburb,
    required this.address,
    required this.state,
    this.postcode,
    required this.addedTime,
    required this.exposureStartTime,
    required this.exposureEndTime,
  });

  factory Site.fromMap(Map<String, dynamic> data) {
    return Site(
      title: data['title'],
      suburb: data['suburb'],
      address: data['street_address'],
      state: data['state'],
      postcode: data['postcode'],
      addedTime: data['added_time'].toDate(),
      exposureStartTime: data['exposure_start_time'].toDate(),
      exposureEndTime: data['exposure_end_time'].toDate(),
    );
  }

  final String title;
  final String suburb;
  final String address;
  final String state;
  final int? postcode;
  final DateTime addedTime;
  final DateTime exposureStartTime;
  final DateTime exposureEndTime;
}
