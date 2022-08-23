import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.0277, 105.8341),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            initialCameraPosition: _kGooglePlex,
            indoorViewEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            compassEnabled: true,
            // liteModeEnabled: true,
            rotateGesturesEnabled: true,
            myLocationButtonEnabled: true,
            buildingsEnabled: true,
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            trafficEnabled: true,
            markers: {
              const Marker(
                markerId: MarkerId("1"),
                position: LatLng(21.0277, 105.8341),
              ),
            },
            circles: {
              Circle(
                circleId: const CircleId('1'),
                center: const LatLng(21.0277, 105.8341),
                radius: 10,
                strokeWidth: 1,
                fillColor: Colors.blueAccent.withOpacity(0.2),
                strokeColor: Colors.blueAccent,
              ),
            },
            tileOverlays: {
              const TileOverlay(
                tileOverlayId: TileOverlayId("1"),
              ),
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
          //   child: Column(children: [
          //     Container(
          //       height: 50.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Colors.white,
          //       ),
          //       child: TextFormField(
          //         // controller: searchController,
          //         decoration: InputDecoration(
          //           contentPadding: const EdgeInsets.symmetric(
          //             horizontal: 20.0,
          //             vertical: 15.0,
          //           ),
          //           border: InputBorder.none,
          //           hintText: 'Search',
          //           suffixIcon: IconButton(
          //             onPressed: () {},
          //             icon: const Icon(Icons.close),
          //           ),
          //         ),
          //         onChanged: (value) {},
          //       ),
          //     )
          //   ]),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    Dio dio = Dio();
    var res = await dio.get(
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json",
        queryParameters: {
          // keyword=cruise
          // &location=-33.8670522%2C151.1957362
          // &radius=1500
          "type": "restaurant",
          "key": "AIzaSyDna5CWJVdWkmSbpMT1MjSIPthgkfxpfpo"
        });

    print(res);
  }
}
