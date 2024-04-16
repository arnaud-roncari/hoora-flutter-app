class CrowdReport {
  final String userId;
  final DateTime createdAt;
  final int duration;
  final int intensity;

  CrowdReport({
    required this.createdAt,
    required this.userId,
    required this.duration,
    required this.intensity,
  });
  // factory CrowdReport.fromJson(Map<String, dynamic> json) {
  //   return CrowdReport(
  //     createdAt: DateTime.parse(json["createdAt"]),
  //     duration: json['duration'],
  //   );
  // }

  // static List<CrowdReport> fromJsons(List<dynamic> jsons) {
  //   final List<CrowdReport> list = [];
  //   for (Map<String, dynamic> json in jsons) {
  //     list.add(CrowdReport.fromJson(json));
  //   }
  //   return list;
  // }
}
