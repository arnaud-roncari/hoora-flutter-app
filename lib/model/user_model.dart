import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String userId;
  final int gem;
  final int experience;
  final int level;
  final String firstname;
  final String lastname;
  final String nickname;
  final String city;
  final String country;
  final String language;
  final String gender;
  final String birthday;
  final String phoneNumber;

  User({
    required this.id,
    required this.userId,
    required this.gem,
    required this.experience,
    required this.level,
    required this.firstname,
    required this.lastname,
    required this.nickname,
    required this.city,
    required this.country,
    required this.language,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
  });

  factory User.fromSnapshot(QueryDocumentSnapshot doc) {
    return User(
      id: doc.id,
      userId: doc["userId"],
      gem: doc['gem'],
      experience: doc['experience'],
      level: doc['level'],
      firstname: doc['firstname'],
      lastname: doc['lastname'],
      nickname: doc['nickname'],
      city: doc['city'],
      country: doc['country'],
      language: doc['language'],
      gender: doc['gender'],
      birthday: doc['birthday'],
      phoneNumber: doc['phoneNumber'],
    );
  }

  static List<User> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<User> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(User.fromSnapshot(doc));
    }
    return list;
  }

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     id: json['id'],
  //     gem: json['gem'],
  //     experience: json['experience'],
  //     level: json['level'],
  //     firstname: json['firstname'],
  //     lastname: json['lastname'],
  //     nickname: json['nickname'],
  //     city: json['city'],
  //     country: json['country'],
  //     language: json['language'],
  //     gender: json['gender'],
  //     birthday: json['birthday'],
  //     phoneNumber: json['phoneNumber'],
  //   );
  // }

  // static Future<List<User>> fromJsons(List<dynamic> jsons) async {
  //   final List<User> list = [];
  //   for (Map<String, dynamic> json in jsons) {
  //     list.add(User.fromJson(json));
  //   }
  //   return list;
  // }
}
