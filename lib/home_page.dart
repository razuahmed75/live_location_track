import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> polyList = [
    LatLng(37.33500926, -122.03272188),
    LatLng(37.33429383, -122.06600055),
  ];

  // List<LatLng> polyLineCoordinates = [];

  // Future getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       GOOGLE_API_KEY,
  //       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //       PointLatLng(destination.latitude, destination.longitude));
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng e) =>
  //         polyLineCoordinates.add(LatLng(e.latitude, e.longitude)));
  //     // result.points.map((PointLatLng e) =>
  //     //     polyLineCoordinates.add(LatLng(e.latitude, e.longitude)));
  //   }
  //   setState(() {});
  // }
  final Set<Polyline> _polylines = {};

  void _addPolyLines() {
    _polylines.add(Polyline(
      polylineId: PolylineId('1'),
      points: polyList,
      color: Colors.blue,
      width: 6,
    ));
  }

  LatLng? currentLocation;
  getCurrentLoc() async {
    Location location = Location();

    location.getLocation().then((l) {
      currentLocation = LatLng(37.334429162989004, -122.04073097247591);
      setState(() {});
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      LatLng loc = LatLng(newLoc.latitude!, newLoc.longitude!);
      currentLocation = loc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(newLoc.latitude!, newLoc.longitude!),zoom: 13.5)));
      setState(() {});
    });
  }

  @override
  void initState() {
    getCurrentLoc();
    _addPolyLines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track order"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: currentLocation == null
          ? Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentLocation!, zoom: 13),
              polylines: _polylines,
              markers: {
                Marker(markerId: MarkerId('1'), position: sourceLocation),
                Marker(markerId: MarkerId('0'), position: currentLocation!),
                Marker(markerId: MarkerId('2'), position: destination),
              },
            ),
    );
  }
}
