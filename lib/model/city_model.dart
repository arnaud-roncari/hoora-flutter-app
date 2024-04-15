import 'package:cloud_firestore/cloud_firestore.dart';

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

  static List<City> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<City> cities = [];
    for (QueryDocumentSnapshot doc in docs) {
      cities.add(City.fromSnapshot(doc));
    }
    return cities;
  }
}
