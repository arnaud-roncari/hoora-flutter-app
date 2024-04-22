import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;

class City {
  final String id;
  final String name;
  final GeoPoint coordinates;

  City({required this.id, required this.name, required this.coordinates});

  factory City.fromSnapshot(QueryDocumentSnapshot doc) {
    return City(
      id: doc.id,
      name: doc['name'],
      coordinates: doc['coordinates'],
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"],
      name: json['name'],
      coordinates: json['coordinates'],
    );
  }

  static List<City> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<City> cities = [];
    for (QueryDocumentSnapshot doc in docs) {
      cities.add(City.fromSnapshot(doc));
    }
    return cities;
  }

  double getLatitude() {
    return coordinates.latitude;
  }

  double getLongitude() {
    return coordinates.longitude;
  }

  Position getPosition() {
    return Position(coordinates.longitude, coordinates.latitude);
  }

  latLng.LatLng getLatLng() {
    return latLng.LatLng(coordinates.latitude, coordinates.longitude);
  }
}
