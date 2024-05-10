import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:http/http.dart' as http;

class SpotRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<List<Spot>> getSpots(Region region, City? city) async {
    if (city == null) {
      QuerySnapshot snapshot = await instance.collection("spot").where("regionId", isEqualTo: region.id).get();
      return Spot.fromSnapshots(snapshot.docs);
    }

    QuerySnapshot snapshot = await instance
        .collection("spot")
        .where("regionId", isEqualTo: region.id)
        .where("cityId", isEqualTo: city.id)
        .get();
    return Spot.fromSnapshots(snapshot.docs);
  }

  Future<bool> spotAlreadyValidated(Spot spot) async {
    QuerySnapshot snapshot = await instance
        .collection("spotValidation")
        .where("spotId", isEqualTo: spot.id)
        .where("userId", isEqualTo: authInstance.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return false;
    }

    DateTime createdAt = (snapshot.docs[0]["createdAt"] as Timestamp).toDate();
    DateTime end = DateTime.now().subtract(const Duration(hours: 24));

    return !createdAt.isBefore(end);
  }

  Future<void> validateSpot(Spot spot) async {
    final url = Uri.parse('https://validatespot-nmciz2db3a-uc.a.run.app');
    await http.post(
      url,
      body: {'spotId': spot.id},
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
  }
}
