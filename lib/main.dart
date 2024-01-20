import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Circle _circle = const Circle(circleId: CircleId('dottedCircle'));
  Polyline _polyline = const Polyline(
    polylineId: PolylineId('dottedPolyLine'),
  );

  @override
  void initState() {
    super.initState();
    _circle =  Circle(
      circleId: const CircleId('dottedCircle'),
      center: const LatLng(20.5937, 78.9629),
      radius:500,
      strokeWidth: 0,
      fillColor: Colors.orangeAccent.withOpacity(.25),
    );
    _polyline = Polyline(
      polylineId: const PolylineId('dottedCircle'),
      color: Colors.deepOrange,
      width: 2,
      patterns: [
        PatternItem.dash(20),
        PatternItem.gap(20),
      ],
      points: List<LatLng>.generate(
          360,
              (index) => calculateNewCoordinates(
              const LatLng(20.5937, 78.9629).latitude,
              const LatLng(20.5937, 78.9629).longitude,
              500,
              double.parse(index.toString()))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        polylines: {_polyline},
        circles: {_circle},
        initialCameraPosition: const CameraPosition(
          target: LatLng(20.5937, 78.9629),
          zoom: 15,
        ),
      ),
    );
  }

  LatLng calculateNewCoordinates(
      double lat, double lon, double radiusInMeters, double angleInDegrees) {
    // Convert angle from degrees to radians
    double PI = 3.141592653589793238;

    double angleInRadians = angleInDegrees * PI / 180;

    // Constants for Earth's radius and degrees per meter
    const earthRadiusInMeters = 6371000; // Approximate Earth radius in meters
    const degreesPerMeterLatitude = 1 / earthRadiusInMeters * 180 / pi;
    final degreesPerMeterLongitude =
        1 / (earthRadiusInMeters * cos(lat * PI / 180)) * 180 / pi;

    // Calculate the change in latitude and longitude in degrees
    double degreesOfLatitude = radiusInMeters * degreesPerMeterLatitude;
    double degreesOfLongitude = radiusInMeters * degreesPerMeterLongitude;

    // Calculate the new latitude and longitude
    double newLat = lat + degreesOfLatitude * sin(angleInRadians);
    double newLon = lon + degreesOfLongitude * cos(angleInRadians);
    return LatLng(newLat, newLon);
  }
}


