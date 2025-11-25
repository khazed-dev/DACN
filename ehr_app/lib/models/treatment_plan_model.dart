import 'package:cloud_firestore/cloud_firestore.dart';

class TreatmentStep {
  final int day;
  final String title;
  final String description;

  TreatmentStep({
    required this.day,
    required this.title,
    required this.description,
  });

  TreatmentStep copyWith({
    int? day,
    String? title,
    String? description,
  }) {
    return TreatmentStep(
      day: day ?? this.day,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'title': title,
      'description': description,
    };
  }

  factory TreatmentStep.fromMap(Map<String, dynamic> map) {
    return TreatmentStep(
      day: (map['day'] ?? 0) as int,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
    );
  }
}

class TreatmentPlan {
  final String planId;
  final String doctorId;
  final String patientId;
  final String diagnosis;
  final String notes;
  final List<TreatmentStep> steps;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TreatmentPlan({
    required this.planId,
    required this.doctorId,
    required this.patientId,
    required this.diagnosis,
    required this.notes,
    required this.steps,
    this.createdAt,
    this.updatedAt,
  });

  TreatmentPlan copyWith({
    String? planId,
    String? doctorId,
    String? patientId,
    String? diagnosis,
    String? notes,
    List<TreatmentStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TreatmentPlan(
      planId: planId ?? this.planId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planId': planId,
      'doctorId': doctorId,
      'patientId': patientId,
      'diagnosis': diagnosis,
      'notes': notes,
      'steps': steps.map((s) => s.toMap()).toList(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory TreatmentPlan.fromMap(Map<String, dynamic> map) {
    final stepsData = (map['steps'] as List<dynamic>? ?? []);
    return TreatmentPlan(
      planId: (map['planId'] ?? '') as String,
      doctorId: (map['doctorId'] ?? '') as String,
      patientId: (map['patientId'] ?? '') as String,
      diagnosis: (map['diagnosis'] ?? '') as String,
      notes: (map['notes'] ?? '') as String,
      steps: stepsData
          .map((e) => TreatmentStep.fromMap(e as Map<String, dynamic>))
          .toList(),
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: (map['updatedAt'] is Timestamp)
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// tiện dùng khi lấy từ DocumentSnapshot
  factory TreatmentPlan.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TreatmentPlan.fromMap({
      ...data,
      'planId': doc.id,
    });
  }
}
