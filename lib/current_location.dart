import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
// import 'dart:html';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';




class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();

}



// void setState(Null Function() param0) {
// }



class _CurrentLocationState extends State<CurrentLocation> {

  Set<Marker> _marker= Set <Marker>();
   @override
  void initState() {
    super.initState();
    _setMarker();
  }

  void _setMarker(LatLng point) {
    setState(() {
      _marker.add(Marker(
        markerId: MarkerId('marker'),
        position: point,
        // infoWindow: InfoWindow(title: placeName)),
      ));
    });
  }


  GoogleMapController? mapController;

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}
LatLng? currentLocation;

  Future<LatLng> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, handle accordingly
    return Future.error('Location services are disabled');
  }

  // Request location permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    // Location permissions are permanently denied, handle accordingly
    return Future.error('Location permissions are permanently denied');
  }

  if (permission == LocationPermission.denied) {
    // Location permissions are denied, request permission
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // Location permissions are denied, handle accordingly
      return Future.error('Location permissions are denied');
    }
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition();
  return LatLng(position.latitude, position.longitude);
}
  @override
void updateCurrentLocation() {
  getCurrentLocation().then((LatLng location) {
    setState(() {
      currentLocation = location;
    });

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(location));
    }
  }).catchError((e) {
    print('Error occurred while retrieving location: $e');
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Location"),),

      body: Column(
        children: <Widget>[
          Expanded(child: GoogleMap(
  onMapCreated: _onMapCreated,
  initialCameraPosition: CameraPosition(
    target: LatLng(0, 0),
    zoom: 12,
  ),
  markers: _marker,
)
)
        ]
      ),
    );
  }
  

}
