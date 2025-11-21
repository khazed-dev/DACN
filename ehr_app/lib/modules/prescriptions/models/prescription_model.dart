import 'package:cloud_firestore/cloud_firestore.dart';
import 'medical_drug.dart';

class Prescription {
  final String prescriptionId;
  final String prescriptionName;
  final String doctorId;
  final String patientId;
  final List<MedicalDrug> drugs;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final String qrCode;
  final String? pharmacistId;
  final DateTime? dispensedAt;

  Prescription({
    required this.prescriptionId,
    required this.prescriptionName,
    required this.doctorId,
    required this.patientId,
    required this.drugs,
    required this.status,
    required this.createdAt,
    required this.qrCode,
    this.updatedAt,
    this.pharmacistId,
    this.dispensedAt,
  });

  factory Prescription.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Prescription(
      prescriptionId: data['prescriptionId'],
      prescriptionName: data['prescriptionName'],
      doctorId: data['doctorId'],
      patientId: data['patientId'],
      drugs: (data['drugs'] as List)
          .map((e) => MedicalDrug.fromMap(e))
          .toList(),
      status: data['status'],
      qrCode: data['qrCode'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] == null
          ? null
          : (data['updatedAt'] as Timestamp).toDate(),
      pharmacistId: data['pharmacistId'],
      dispensedAt: data['dispensedAt'] == null
          ? null
          : (data['dispensedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prescriptionId': prescriptionId,
      'prescriptionName': prescriptionName,
      'doctorId': doctorId,
      'patientId': patientId,
      'drugs': drugs.map((d) => d.toMap()).toList(),
      'status': status,
      'qrCode': qrCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'pharmacistId': pharmacistId,
      'dispensedAt': dispensedAt,
    };
  }

  Prescription copyWith({
    String? prescriptionId,
    String? prescriptionName,
    String? doctorId,
    String? patientId,
    List<MedicalDrug>? drugs,
    String? status,
    String? qrCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? pharmacistId,
    DateTime? dispensedAt,
  }) {
    return Prescription(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      prescriptionName: prescriptionName ?? this.prescriptionName,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      drugs: drugs ?? this.drugs,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pharmacistId: pharmacistId ?? this.pharmacistId,
      dispensedAt: dispensedAt ?? this.dispensedAt,
    );
  } 
}
