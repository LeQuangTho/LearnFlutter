import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../BLOC/user_remote/models/forms/esign_get_proposal_form.dart';
import '../BLOC/user_remote/models/forms/esign_request_signing_form.dart';

class GeolocatorHelper {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  final Geolocator geolocator = Geolocator();
  Future<ESignLocation?> getCurrentPosition() async {
    try {
      await determinePosition();
      final Position position = await Geolocator.getCurrentPosition();
      final ESignLocation? eSignGetProposalFileLocation = ESignLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          geoLocation: "Fake - Hanoi, VietNam");
      return eSignGetProposalFileLocation;
    } catch (e) {
      return null;
    }
  }

  Future<ESignRequestSigningFormLocation?>
      getCurrentPositionForRequestSigning() async {
    try {
      await determinePosition();
      final Position position = await Geolocator.getCurrentPosition();
      final ESignRequestSigningFormLocation? eSignGetProposalFileLocation =
          ESignRequestSigningFormLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              geoLocation: "Fake - Hanoi, VietNam");
      return eSignGetProposalFileLocation;
    } catch (e) {
      return null;
    }
  }
}
