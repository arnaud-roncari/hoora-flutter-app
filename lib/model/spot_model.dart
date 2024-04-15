import 'package:hoora/model/category_model.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/crowd_report_model.dart';
import 'package:hoora/model/gems_awarded_model.dart';
import 'package:hoora/model/open_hours_model.dart';

/// TODO les champs doivent être populate > faire un cloud function ? > oui, car on voi envoyé un paramètres 'ville' (avec id)
class Spot {
  final String id;
  final String name;
  final List<double> coordinates;
  final City city;
  final List<Category> categories;
  final GemsAwarded gemsAwarded;
  final OpenHours openHours;
  final List<CrowdReport> crowdReports;
  final DateTime balanceExpireAt;
  final DateTime pulseExpireAt;

  Spot({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.city,
    required this.categories,
    required this.gemsAwarded,
    required this.openHours,
    required this.crowdReports,
    required this.balanceExpireAt,
    required this.pulseExpireAt,
  });

  // factory Spot.fromJson(Map<String, dynamic> json) {
  //   return Spot(
  //     id: json['id'],
  //     name: json['name'],
  //     coordinates: List<double>.from(json['coordinates']),
  //     city: City.fromJson(json['city']),
  //     categories: Category.fromJsons(json['categories']),
  //     gemsAwarded: GemsAwarded.fromJson(json['gemsAwarded']),
  //     openHours: OpenHours.fromJson(json['openHours']),
  //     crowdReports: CrowdReport.fromJsons(json['crowdReports']),
  //     balanceExpireAt: DateTime.parse(json["balanceExpireAt"]),
  //     pulseExpireAt: DateTime.parse(json["pulseExpireAt"]),
  //   );
  // }

  // static Future<List<Spot>> fromJsons(List<dynamic> jsons) async {
  //   final List<Spot> list = [];
  //   for (Map<String, dynamic> json in jsons) {
  //     list.add(Spot.fromJson(json));
  //   }
  //   return list;
  // }
}
