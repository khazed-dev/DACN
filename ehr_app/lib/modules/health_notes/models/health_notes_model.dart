import 'package:cloud_firestore/cloud_firestore.dart';

class HealthNotes {
  final String userId;
  final String did;
  final List<String> conditions;
  final List<String> allergies;
  final DateTime updatedAt;

  HealthNotes({
    required this.userId,
    required this.did,
    required this.conditions,
    required this.allergies,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "did": did,
      "conditions": conditions,
      "allergies": allergies,
      "updatedAt": updatedAt,
    };
  }

  factory HealthNotes.fromMap(Map<String, dynamic> map) {
    return HealthNotes(
      userId: map["userId"],
      did: map["did"],
      conditions: List<String>.from(map["conditions"] ?? []),
      allergies: List<String>.from(map["allergies"] ?? []),
      updatedAt: (map["updatedAt"] as Timestamp).toDate(),
    );
  }
}
