import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'dart:convert' as convert;
// import 'dart:html';

class LocationService {
  final String key = 'AIzaSyD79hEbrrlDT2ko8JSpUrjgzIv7PjAwSTk';

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

    var json = convert.jsonDecode(response.body);

    
    if (json['candidates'] != null && json['candidates'].isNotEmpty) {
        var placeId = json['candidates']['place_id'] as String;
        print(placeId);

        return placeId;
      } else {
        throw Exception('No candidates found in the response');
      }
    // var placeId = json['candidates'][0]['place_id'] as String;

    // return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    // final placeId = await getPlace(input);
    final placeId = await getPlaceId(input);
    final String url =
        'http://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }
}
