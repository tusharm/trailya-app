import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Assets {
  static BitmapDescriptor? redMarkerIcon;
  static BitmapDescriptor? blueMarkerIcon;

  static Future<void> init() async {
    redMarkerIcon = await _loadImage('assets/red-marker.png', 150);
    blueMarkerIcon = await _loadImage('assets/blue-marker.png', 150);
  }

  static Future<BitmapDescriptor> _loadImage(String path, int width) async {
    final redMarkerIconBytes = await _getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(redMarkerIconBytes);
  }

  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final fi = await codec.getNextFrame();
    final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
