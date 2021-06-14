class Site {
  final String id;
  final String suburb;
  final String name;
  final String address;
  final String state;
  final String postcode;
  final String exposureDate;
  final String exposureStartTime;
  final String exposureEndTime;

  Site({
    required this.id,
    required this.suburb,
    required this.name,
    required this.address,
    required this.state,
    required this.postcode,
    required this.exposureDate,
    required this.exposureStartTime,
    required this.exposureEndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'suburb': suburb,
      'name': name,
      'address': address,
      'state': state,
      'postcode': postcode,
      'exposure_date': exposureDate,
      'exposure_time_start': exposureStartTime,
      'exposure_time_end': exposureEndTime
    };
  }

  @override
  String toString() {
    return 'Site{id: $id, name: $name, suburb: $suburb, address: $address, state: $state, postcode: $postcode, date: $exposureDate}';
  }
}
