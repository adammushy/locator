import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'dart:convert' as convert;
// import 'dart:html';

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

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print(json);
    print("tupate eneo----------");
    print(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    print(results);
    return results;
    // var results = {
    //   'bounds_ne':
    // };
    // var placeName = json['place_name'] as String;
    // var results = json['result'] as Map<String, dynamic>;
    // var placeName = json['place_name'] as String;
    // print(placeName);

    // print(results);
    // return results;
  }
}
