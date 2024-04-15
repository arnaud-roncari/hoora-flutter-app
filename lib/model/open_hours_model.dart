/// TODO intégrer les heures exceptionnelles de fermeture (map par jour)
class OpenHours {
  final String id;

  /// Hour to bool (open/close)
  final Map<int, bool> monday;
  final Map<int, bool> tuesday;
  final Map<int, bool> wednesday;
  final Map<int, bool> thursday;
  final Map<int, bool> friday;
  final Map<int, bool> saturday;
  final Map<int, bool> sunday;

  OpenHours({
    required this.id,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory OpenHours.fromJson(Map<String, dynamic> json) {
    return OpenHours(
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
}
