import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/category_model.dart';

class CategoryRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    QuerySnapshot snapshot = await instance.collection("category").get();
    return Category.fromSnapshots(snapshot.docs);
  }
}
