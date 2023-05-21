import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locator/location_services.dart';
// import 'directions.dart';
// import 'map_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Locator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
      ),
      // home: MapScreen(),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.814988, 39.279366),
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
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locator'),
      ),
      body: Column(
        children: [
          // SizedBox(height: 50,),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hintText: 'Search by city'),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_searchController.text);
                  _goToPlace(place);
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
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

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );
    _setMarker(LatLng(lat, lng));
  }

  // Future<void> _goToDit() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_dit));
  // }
}
