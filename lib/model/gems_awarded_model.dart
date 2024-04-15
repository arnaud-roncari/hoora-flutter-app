class GemsAwarded {
  final String id;

  /// Hour to gems.
  final Map<int, int> monday;
  final Map<int, int> tuesday;
  final Map<int, int> wednesday;
  final Map<int, int> thursday;
  final Map<int, int> friday;
  final Map<int, int> saturday;
  final Map<int, int> sunday;

  GemsAwarded({
    required this.id,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory GemsAwarded.fromJson(Map<String, dynamic> json) {
    return GemsAwarded(
      id: json['id'],
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
    );
  }

  static List<GemsAwarded> fromJsons(List<dynamic> jsons) {
    final List<GemsAwarded> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(GemsAwarded.fromJson(json));
    }
    return list;
  }
}
