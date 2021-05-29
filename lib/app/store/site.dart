import 'package:flutter/material.dart';

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
      "id": this.id,
      "suburb": this.suburb,
      "name": this.name,
      "address": this.address,
      "state": this.state,
      "postcode": this.postcode,
      "exposure_date": this.exposureDate,
      "exposure_time_start": this.exposureStartTime,
      "exposure_time_end": this.exposureEndTime
    };
  }

  @override
  String toString() {
    return 'Site{id: $id, name: $name, suburb: $suburb, address: $address, state: $state, postcode: $postcode, date: $exposureDate}';
  }
}
