import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

class PlaceSearch{
  final List<String> types;
  final String name;
  final Geometry geometry;
  final num rating;

  PlaceSearch({required this.types, required this.name, required this.geometry, required this.rating});
/*
  factory PlaceSearch.fromJson(Map<String, dynamic> json){
    return PlaceSearch(
        types: json['description'],
        name: json['place_id'],
        geometry: json['geometry'],
    );
  }*/

}