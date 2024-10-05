// emergency_info.dart
import 'package:flutter/material.dart';

class EmergencyInfo {
  final String regionId;
  final String emergencyMessage;
  final String emergencyTime;
  final String urgency;

  EmergencyInfo({
    required this.regionId,
    required this.emergencyMessage,
    required this.emergencyTime,
    required this.urgency,
  });

  factory EmergencyInfo.fromJson(Map<String, dynamic> json) {
    return EmergencyInfo(
      regionId: json['region_id'],
      emergencyMessage: json['emergency_message'],
      emergencyTime: json['emergency_time'],
      urgency: json['urgency'],
    );
  }

  Color getColor() {
    switch (urgency) {
      case '1':
        return Colors.green.shade100;
      case '2':
        return Colors.yellow.shade100;
      case '3':
        return Colors.red.shade100;
      default:
        return Colors.white;
    }
  }
}
