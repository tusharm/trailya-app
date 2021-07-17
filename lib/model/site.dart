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
    this.latitude,
    this.longitude,
  });

  factory Site.fromMap(Map<String, dynamic> data) {
    return Site(
      title: data['title'],
      suburb: data['suburb'] ?? '',
      address: data['street_address'] ?? '',
      state: data['state'],
      postcode: data['postcode'],
      addedTime: data['added_time'].toDate(),
      exposureStartTime: data['exposure_start_time'].toDate(),
      exposureEndTime: data['exposure_end_time'].toDate(),
      latitude: data['latitude'],
      longitude: data['longitude'],
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
  double? latitude;
  double? longitude;

  String get uniqueId {
    final replaced = address.replaceAll(RegExp(r'[\s,()]'), '_');
    return '${replaced}_${addedTime.millisecondsSinceEpoch}_${exposureStartTime
        .millisecondsSinceEpoch}_${exposureEndTime.millisecondsSinceEpoch}';
  }
}
