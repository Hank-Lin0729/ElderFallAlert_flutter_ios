// elder_info.dart
class ElderInfo {
  final int elderId;
  final int regionId; // 修改為 int
  final String elderName;

  ElderInfo({
    required this.elderId,
    required this.regionId,
    required this.elderName,
  });

  factory ElderInfo.fromJson(Map<String, dynamic> json) {
    return ElderInfo(
      elderId: json['elder_id'],
      regionId: json['region_id'], // region_id 為 int
      elderName: json['elder_name'],
    );
  }
}
