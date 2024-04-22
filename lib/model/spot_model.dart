import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/category_model.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/crowd_report_model.dart';

class ExceptionalOpenHours {
  final DateTime date;
  final Map<String, bool> openHours;

  factory ExceptionalOpenHours.fromJson(Map<String, dynamic> json) {
    return ExceptionalOpenHours(
      date: (json["date"] as Timestamp).toDate(),
      openHours: Map<String, bool>.from(json["openHours"]),
    );
  }

  static List<ExceptionalOpenHours> fromJsons(List<dynamic> jsons) {
    final List<ExceptionalOpenHours> hour = [];
    for (Map<String, dynamic> json in jsons) {
      hour.add(ExceptionalOpenHours.fromJson(json));
    }
    return hour;
  }

  ExceptionalOpenHours({required this.date, required this.openHours});
}

class BalancePremium {
  final DateTime from;
  final DateTime to;
  final int gem;

  BalancePremium({required this.from, required this.to, required this.gem});

  factory BalancePremium.fromSnapshot(QueryDocumentSnapshot doc) {
    return BalancePremium(
      from: (doc["from"] as Timestamp).toDate(),
      to: (doc["to"] as Timestamp).toDate(),
      gem: doc['gem'],
    );
  }
  factory BalancePremium.fromJson(Map<String, dynamic> json) {
    return BalancePremium(
      from: (json["from"] as Timestamp).toDate(),
      to: (json["to"] as Timestamp).toDate(),
      gem: json['gem'],
    );
  }
}

class PulsePremium {
  final DateTime from;
  final DateTime to;
  final int gem;

  PulsePremium({required this.from, required this.to, required this.gem});

  factory PulsePremium.fromSnapshot(QueryDocumentSnapshot doc) {
    return PulsePremium(
      from: (doc["from"] as Timestamp).toDate(),
      to: (doc["to"] as Timestamp).toDate(),
      gem: doc['gem'],
    );
  }

  factory PulsePremium.fromJson(Map<String, dynamic> json) {
    return PulsePremium(
      from: (json["from"] as Timestamp).toDate(),
      to: (json["to"] as Timestamp).toDate(),
      gem: json['gem'],
    );
  }
}

class Spot {
  final String id;
  final String name;
  final String imageCardPath;
  final GeoPoint coordinates;
  final City city;
  final List<Category> categories;
  final List<Map<String, int>> gemsPerDays;
  final List<Map<String, bool>> openHours;
  final List<ExceptionalOpenHours> exceptionalOpenHours;
  final List<CrowdReport> crowdReports;
  final BalancePremium? balancePremium;
  final PulsePremium? pulsePremium;
  final double rating;

  Spot({
    required this.id,
    required this.name,
    required this.imageCardPath,
    required this.coordinates,
    required this.city,
    required this.categories,
    required this.gemsPerDays,
    required this.openHours,
    required this.exceptionalOpenHours,
    required this.crowdReports,
    required this.rating,
    this.balancePremium,
    this.pulsePremium,
  });

  factory Spot.fromSnapshot(QueryDocumentSnapshot doc) {
    return Spot(
      id: doc.id,
      name: doc['name'],
      imageCardPath: doc['imageCardPath'],
      coordinates: doc['coordinates'],
      city: City.fromJson(doc['city']),
      categories: Category.fromJsons(doc['categories']),
      gemsPerDays: List<Map<String, int>>.from(doc["gemsPerDays"].map((from) {
        Map<String, int> to = Map<String, int>.from(from);
        return to;
      })),
      openHours: List<Map<String, bool>>.from(doc["openHours"].map((from) {
        Map<String, bool> to = Map<String, bool>.from(from);
        return to;
      })),
      exceptionalOpenHours: ExceptionalOpenHours.fromJsons(doc["exceptionalOpenHours"]),
      crowdReports: CrowdReport.fromJsons(doc["crowdReports"]),
      rating: doc["rating"] is int ? (doc["rating"] as int).toDouble() : doc["rating"],
      balancePremium: doc["balancePremium"] == null ? null : BalancePremium.fromJson(doc["balancePremium"]),
      pulsePremium: doc["pulsePremium"] == null ? null : PulsePremium.fromJson(doc["pulsePremium"]),
    );
  }

  static List<Spot> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Spot> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Spot.fromSnapshot(doc));
    }
    return list;
  }

  bool isClosedAt(DateTime date, int hour) {
    for (ExceptionalOpenHours exceptionalOpenHours in exceptionalOpenHours) {
      DateTime day = exceptionalOpenHours.date;

      if (date.month == day.month && date.day == day.day) {
        return !exceptionalOpenHours.openHours[hour.toString()]!;
      }
    }
    return !openHours[date.weekday - 1][hour.toString()]!;
  }

  bool isCrowdedAt(DateTime date, int selectedHour) {
    if (crowdReports.isEmpty) {
      return false;
    }

    DateTime from = crowdReports.last.createdAt;
    DateTime to = from.add(const Duration(hours: 2));

    if (date.year == from.year && date.month == from.month && date.day == from.day) {
      if (selectedHour >= from.hour && selectedHour <= to.hour) {
        return crowdReports.last.intensity > 4;
      }
    }
    return false;
  }

  String getCrowdedAwaitingTime() {
    if (crowdReports.isEmpty) {
      return '0\'';
    }

    int hour = crowdReports.last.hour;
    int minute = crowdReports.last.minute;

    if (hour < 1) {
      return '$minute\'';
    }

    if (minute < 15) {
      return '${hour}h';
    }

    return '${hour}h$minute';
  }

  bool isSponsoredAt(DateTime date, int hour) {
    if (isBalanceSponsoredAt(date, hour) || isPulseSponsoredAt(date)) {
      return true;
    }
    return false;
  }

  bool isPulseSponsoredAt(DateTime date) {
    if (pulsePremium == null) {
      return false;
    }

    if (date.isAfter(pulsePremium!.from) && date.isBefore(pulsePremium!.to)) {
      return true;
    }
    return false;
  }

  bool isBalanceSponsoredAt(DateTime date, int hour) {
    if (balancePremium == null) {
      return false;
    }

    if (date.isAfter(balancePremium!.from) && date.isBefore(balancePremium!.to)) {
      int gems = gemsPerDays[date.weekday - 1][hour.toString()]!;
      if (gems <= 0) {
        return false;
      }

      return true;
    }
    return false;
  }

  bool hasDiscoveryPoints() {
    return rating > 4.5;
  }

  bool hasCategory(Category? category) {
    if (category == null) {
      return true;
    }

    for (Category cat in categories) {
      if (cat.id == category.id) {
        return true;
      }
    }
    return false;
  }

  int getGemsAt(DateTime date, int hour) {
    int gems = gemsPerDays[date.weekday - 1][hour.toString()]!;

    if (gems > 0 && isBalanceSponsoredAt(date, hour)) {
      gems += balancePremium!.gem;
    }

    if (isPulseSponsoredAt(date)) {
      gems += pulsePremium!.gem;
    }

    if (hasDiscoveryPoints()) {
      gems += 5;
    }

    return gems;
  }
}
