import 'dart:async';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'dart:convert' as convert;
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:locator/location_services.dart';

// import 'main.dart';
// import 'directions.dart';


class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState1();
}

class MapSampleState1 extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();

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
    _setMarker(LatLng(-6.814988, 39.279366),'Dit');
  }

  void _setMarker(LatLng point ,placeName) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
          infoWindow: InfoWindow(title:placeName )
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
    final String placeName = place['name'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
    _setMarker(LatLng(lat, lng), placeName);
  }

  // Future<void> _goToDit() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_dit));
  // }
}


class LocationService {
  final String key = 'AIzaSyCHrIPck8HnlOsi5KD7jXbQBSPx_7mJ3n4';

  // Future<String> getPlaceId(String input) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

  //   try {
  //     var response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       var json = convert.jsonDecode(response.body);

  //       if (json['candidates'] != null && json['candidates'].isNotEmpty) {
  //         var placeId = json['candidates'][0]['place_id'] as String;

  //         print(placeId);
  //         print("--------------------------");

  //         return placeId;
  //       } else {
  //         throw Exception('No candidates found in the response');
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to retrieve place ID. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error occurred while fetching place ID: $e');
  //   }
  // }

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));

    print("passed heree 1");
    var json = convert.jsonDecode(response.body);
    // var placeName = json['place_name'] as String;
    print("passed heree 2-------------");

    print(response);
    print(response.body);

    // if (json['candidates'] != null && json['candidates'].isNotEmpty) {
    //   var placeId = json['candidates'][0]['place_id'] as String;
    //   print(placeId);

    //   return placeId;
    // } else {
    //   throw Exception('No candidates found in the response');
    // }
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    // final placeId = await getPlace(input);
    // print("tuanze tupate eneo----------");

    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print("tupate eneo----------");
    print(response.body);
    // var placeName = json['place_name'] as String;
    var results = json['result'] as Map<String, dynamic>;
    // var placeName = json['place_name'] as String;
    // print(placeName);
    
    

    print(results);
    return results;
  }
}
