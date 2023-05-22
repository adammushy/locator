import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/location_services.dart';

// import 'main.dart';
// import 'directions.dart';

class MapSample1 extends StatefulWidget {
  const MapSample1({super.key});

  @override
  State<MapSample1> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample1> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  int _polylineIdCounter = 1;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.81, 39.27),
    zoom: 14.4746,
  );

  // static const CameraPosition _dit = CameraPosition(
  //     bearing: 12.8334901395799,
  //     target: LatLng(-6.814988, 39.279366),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    _setMarker(LatLng(-6.814988, 39.279366));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('marker'),
        position: point,
        // infoWindow: InfoWindow(title: placeName)),
      ));
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(
      Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 4,
          color: Colors.blue,
          points: points
              .map(
                (point) => LatLng(point.latitude, point.longitude),
              )
              .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locator'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      // textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(hintText: 'Start'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextFormField(
                      controller: _destinationController,
                      // textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(hintText: 'Destination'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  var directions = await LocationService().getDirections(
                    _originController.text,
                    _destinationController.text,
                  );
                  print("get ready to get directions");
                  print(directions);
                  // var place =
                  //     await LocationService().getPlace(_searchController.text);
                  //       _goToPlace(place);
                  _goToPlace(
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                    directions['start_location']['lat'],
                    directions['start_location']['lng'],
                  );
                  _setPolyline(directions['polyline_decoded']);
                },
                icon: const Icon(Icons.search),
              ),
            ],
          )
          // SizedBox(height: 50,),
          // Row(
          //   children: [

          //     IconButton(
          //       onPressed: () async {
          //         var place =
          //             await LocationService().getPlace(_searchController.text);
          //               _goToPlace(place);
          //       },
          //       icon: const Icon(Icons.search),
          //     ),
          //   ],
          // ),
          ,
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              polylines: _polylines,
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToDit,
      //   // code where to place floatactionbutton
      //   label: const Text('visit DIT'),
      //   icon: const Icon(Icons.directions_bus_filled_outlined),
      // ),
    );
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
    double lat,
    double lng,
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    // final String placeName = place['name'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));
    _setMarker(LatLng(lat, lng));
  }

  // Future<void> _goToDit() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_dit));
  // }
}
