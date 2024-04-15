import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/city_model.dart';

class CityRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<City>> getAllCities() async {
    QuerySnapshot snapshot = await instance.collection("city").get();
    return City.fromSnapshots(snapshot.docs);
  }
}
