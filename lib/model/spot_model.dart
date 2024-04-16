import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/category_model.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/crowd_report_model.dart';

/// TODO comment améliorer le chargment des photos ? (gestion du cache)
class Spot {
  final String id;
  final String name;
  final String imageCardPath;
  final GeoPoint coordinates;
  final City city;
  final List<Category> categories;
  final List<List<Map<int, int>>> gemsPerHours;
  final List<Map<int, bool>> openHours;
  final Map<DateTime, Map<int, bool>> exceptionalOpenHours;
  final List<CrowdReport> crowdReports;
  final DateTime? balanceExpireAt;
  final DateTime? pulseExpireAt;
  final double rating;

  Spot({
    required this.id,
    required this.name,
    required this.imageCardPath,
    required this.coordinates,
    required this.city,
    required this.categories,
    required this.gemsPerHours,
    required this.openHours,
    required this.exceptionalOpenHours,
    required this.crowdReports,
    required this.rating,
    this.balanceExpireAt,
    this.pulseExpireAt,
  });

  bool isClosedAt(DateTime date, int hour) {
    for (DateTime key in exceptionalOpenHours.keys) {
      if (date.month == key.month && date.day == key.day) {
        return !exceptionalOpenHours[key]![hour]!;
      }
    }
    return !openHours[date.weekday - 1][hour]!;
  }

  bool isCrowdedAt(DateTime date, int selectedHour) {
    if (crowdReports.isEmpty) {
      return false;
    }

    DateTime from = crowdReports.last.createdAt;
    DateTime to = from.add(Duration(hours: crowdReports.last.duration));

    if (date.year == from.year && date.month == from.month && date.day == from.day) {
      if (selectedHour >= from.hour && selectedHour <= to.hour) {
        return crowdReports.last.intensity > 4;
      }
    }
    return false;
  }

  bool isSponsoredAt(DateTime date) {
    if (isBalanceSponsoredAt(date) || isPulseSponsoredAt(date)) {
      return true;
    }
    return false;
  }

  bool isPulseSponsoredAt(DateTime date) {
    if (pulseExpireAt != null) {
      final Duration difference = pulseExpireAt!.difference(date);
      if (difference.inDays > 0) {
        return true;
      }
    }
    return false;
  }

  bool isBalanceSponsoredAt(DateTime date) {
    if (balanceExpireAt != null) {
      final Duration difference = balanceExpireAt!.difference(date);
      if (difference.inDays > 0) {
        return true;
      }
    }
    return false;
  }

  bool hasDiscoveryPoints() {
    return rating > 4.5;
  }

  int getGemsAt(DateTime date, int hour) {
    int gems = gemsPerHours.last[date.weekday - 1][hour]!;

    /// TODO ma couleur sponsorié doit petre affiché malgrés le fait qu'il y est pas de points ? (le cas étant inférieur à 10)
    if (gems >= 10 && isBalanceSponsoredAt(date)) {
      gems += 10;
    }

    if (isPulseSponsoredAt(date)) {
      gems += 5;
    }

    if (hasDiscoveryPoints()) {
      gems += 5;
    }

    return gems;
  }

  // factory Spot.fromJson(Map<String, dynamic> json) {
  //   return Spot(
  //     id: json['id'],
  //     name: json['name'],
  //     coordinates: List<double>.from(json['coordinates']),
  //     city: City.fromJson(json['city']),
  //     categories: Category.fromJsons(json['categories']),
  //     gemsPerHours: gemsPerHours.fromJson(json['gemsPerHours']),
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
