import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String imagePath;

  Category({required this.id, required this.name, required this.imagePath});

  factory Category.fromSnapshot(QueryDocumentSnapshot doc) {
    return Category(
      id: doc.id,
      name: doc['name'],
      imagePath: doc['imagePath'],
    );
  }

  static List<Category> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Category> categories = [];
    for (QueryDocumentSnapshot doc in docs) {
      categories.add(Category.fromSnapshot(doc));
    }
    return categories;
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }

  static List<Category> fromJsons(List<dynamic> jsons) {
    final List<Category> categories = [];
    for (Map<String, dynamic> json in jsons) {
      categories.add(Category.fromJson(json));
    }
    return categories;
  }
}
