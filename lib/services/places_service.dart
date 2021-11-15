import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:to_eat/models/place_search.dart';



class PlacesService {
  /*
  Future<List<PlaceSearch>> getAutoComplete(String search) async{
    const apiKey = "AIzaSyAHjT0YcRUm-Y-UQ902hQdEIacZz1Mt7vI";
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=$apiKey&types%3Destablishment';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonRes = json['predictions'] as List;
    return jsonRes.map((place) => PlaceSearch.fromJson(place)).toList();
  }*/

  Future<PlacesSearchResponse> getNearybyRestaraunts(String search, Position currentLocation, num radius) async{
    const apiKey = "AIzaSyAHjT0YcRUm-Y-UQ902hQdEIacZz1Mt7vI";
    var places = GoogleMapsPlaces(apiKey: apiKey);

    PlacesSearchResponse response = await places.searchByText(search,
        location: Location(lat: currentLocation.latitude, lng: currentLocation.longitude),
        radius: radius,
        type: "restaurant",
        opennow: true);

    for (var element in response.results) {
      var isRestaurant = false;
      for (var element in element.types) {
        if("restaurant" == element || "food" == element){
          isRestaurant = true;
        }
      }
      if(!isRestaurant){
        response.results.remove(element);
      }
    }
    return response;
  }
  
  Future<List<PlaceSearch>> getRestaurants(String search, Position currentLocation, num radius) async{
    const apiKey = "AIzaSyAHjT0YcRUm-Y-UQ902hQdEIacZz1Mt7vI";
    var places = GoogleMapsPlaces(apiKey: apiKey);

    PlacesSearchResponse response = await places.searchByText(search,
        location: Location(lat: currentLocation.latitude, lng: currentLocation.longitude),
        radius: radius,
        type: "restaurant",
        opennow: true);

    List<PlacesSearchResult> toRemove = [];
    for (var element in response.results) {
      var isRestaurant = false;
      for (var element in element.types) {
        if("restaurant" == element || "food" == element){
          isRestaurant = true;
        }
      }
      var _distanceInMeters = await Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, element.geometry!.location.lat, element.geometry!.location.lng);
      if(!isRestaurant || _distanceInMeters > radius){
        toRemove.add(element);
      }
    }
    response.results.removeWhere((element) => toRemove.contains(element));
    
    List<PlaceSearch> results = [];
    for (var element in response.results) {
      var pl = PlaceSearch(
          types: element.types,
          name: element.name,
          geometry: element.geometry!,
          rating: element.rating!
      );
      results.add(pl);
    }
    return results;
  }
}