import 'package:cloud_firestore/cloud_firestore.dart';

class CrowdReport {
  final String userId;
  final DateTime createdAt;
  final int hour;
  final int minute;
  final int intensity;

  CrowdReport({
    required this.createdAt,
    required this.userId,
    required this.hour,
    required this.minute,
    required this.intensity,
  });

  factory CrowdReport.fromSnapshot(QueryDocumentSnapshot doc) {
    return CrowdReport(
      userId: doc['userId'],
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      hour: doc['hour'],
      minute: doc['minute'],
      intensity: doc['intensity'],
    );
  }

  static List<CrowdReport> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<CrowdReport> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(CrowdReport.fromSnapshot(doc));
    }
    return list;
  }

  factory CrowdReport.fromJson(Map<String, dynamic> json) {
    return CrowdReport(
      userId: json['userId'],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      hour: json['hour'],
      minute: json['minute'],
      intensity: json['intensity'],
    );
  }

  static List<CrowdReport> fromJsons(List<dynamic> jsons) {
    final List<CrowdReport> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(CrowdReport.fromJson(json));
    }
    return list;
  }
}
