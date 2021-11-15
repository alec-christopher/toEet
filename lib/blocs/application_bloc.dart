
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:to_eat/models/place_search.dart';
import 'package:to_eat/services/geolocator_service.dart';
import 'package:to_eat/services/places_service.dart';

class ApplicationBloc with ChangeNotifier{
  final geoLocatorService = GeoLocatorService();
  final placesService = PlacesService();

  // vars
  late Position? currentLocation;
  late List<PlaceSearch> autoCompleteSearchResults = [];

  late Set<Marker> markers = {};
  /*late PlacesSearchResponse response;*/
  late List<ListTile> wheelItems = [];
  late List<String> selections = [
  ];
  late Map<String, List<PlaceSearch>> searchResults = {};



  var sliderValue = 2.0;
  //late List<PlaceSearch> results = [];
  ApplicationBloc() {
    setCurrentLocation();
  }

  setSlider(value){
    sliderValue = value;
    notifyListeners();
  }

  getSliderValue(){
    return sliderValue;
  }


  removeSelection(int index){
    selections.removeAt(index);
    notifyListeners();
  }

  distanceReset() async{
    markers.clear();
    for (var value in selections) {
      await addResults(value, sliderValue);
    }
    notifyListeners();
  }

  clearMarkers(){
    //markers.clear();
    notifyListeners();
  }

  bool addSelection(String value){
    if(!selections.contains(value)) {
      selections.add(value.toLowerCase());
      notifyListeners();
      return true;
    }
    return false;
  }

  setCurrentLocation() async{
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }


  addResults(String search, num sliderValue) async{
    var results = await placesService.getRestaurants(search.toLowerCase(), currentLocation!, sliderValue * 1600);
    searchResults[search.toLowerCase()] = results;
    await addMarkers();
    notifyListeners();
  }

  removeResults(String value) async{
    searchResults.remove(value);
    markers.clear();
    await addMarkers();
    notifyListeners();
  }


  addMarkers() async{
    wheelItems.clear();
    searchResults.forEach((key, value) {
      markers.addAll(value.map((result) => Marker(
          markerId: MarkerId(result.name),
          // Use an icon with different colors to differentiate between current location
          // and the restaurants
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          infoWindow: InfoWindow(
              title: result.name,
              snippet: 'Ratings: ${result.rating}'
          ),
          position: LatLng(
              result.geometry.location.lat, result.geometry.location.lng)
      )).toSet());
      notifyListeners();
      wheelItems += value
          .map((result) => ListTile(
        title: Text(result.name),
      ))
          .toList();
      notifyListeners();
    });

    notifyListeners();
  }

}