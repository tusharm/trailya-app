import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Assets {
  static BitmapDescriptor? redMarkerIcon;
  static BitmapDescriptor? blueMarkerIcon;

  static Future<void> init() async {
    redMarkerIcon = await _getMarkerBitmap(75, Colors.red);
    blueMarkerIcon = await _getMarkerBitmap(75, Colors.blueAccent);
  }

  static Future<BitmapDescriptor> _getMarkerBitmap(
      int size, Color color) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint1 = Paint()..color = color;
    final paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    final img = await pictureRecorder.endRecording().toImage(size, size);
    return _imageToBitmap(img);
  }

  static Future<BitmapDescriptor> _imageToBitmap(ui.Image image) async {
    final data =
        await image.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
