class User {
  final String id;
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      gem: json['gem'],
      experience: json['experience'],
      level: json['level'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      nickname: json['nickname'],
      city: json['city'],
      country: json['country'],
      language: json['language'],
      gender: json['gender'],
      birthday: json['birthday'],
      phoneNumber: json['phoneNumber'],
    );
  }

  static Future<List<User>> fromJsons(List<dynamic> jsons) async {
    final List<User> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(User.fromJson(json));
    }
    return list;
  }
}
