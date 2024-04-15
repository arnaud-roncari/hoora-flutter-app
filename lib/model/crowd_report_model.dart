/// TODO only the last report is displayed
class CrowdReport {
  final String id;
  final DateTime createdAt;
  final int duration;

  factory CrowdReport.fromJson(Map<String, dynamic> json) {
    return CrowdReport(
      id: json['id'],
      createdAt: DateTime.parse(json["createdAt"]),
      duration: json['duration'],
    );
  }

  CrowdReport({required this.id, required this.createdAt, required this.duration});

  static List<CrowdReport> fromJsons(List<dynamic> jsons) {
    final List<CrowdReport> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(CrowdReport.fromJson(json));
    }
    return list;
  }
}
