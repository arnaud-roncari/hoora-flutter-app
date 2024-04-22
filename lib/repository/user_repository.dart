import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hoora/model/user_model.dart';

class UserRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<User> getUser() async {
    String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await instance.collection("user").where("userId", isEqualTo: userId).get();
    return User.fromSnapshot(snapshot.docs[0]);
  }
}
