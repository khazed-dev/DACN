import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prescription_model.dart';

class PrescriptionService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection("prescriptions");

  /// ========================
  /// 🧑‍⚕️ BÁC SĨ TẠO ĐƠN THUỐC
  /// ========================
  Future<void> deletePrescription(String id) async {
  await _collection.doc(id).delete();
}

  Future<void> createPrescription(Prescription prescription) async {
    final docRef = _collection.doc();

    final newPrescription = prescription.copyWith(
      prescriptionId: docRef.id,
      qrCode: docRef.id,
      status: "pending",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(newPrescription.toMap());
  }

  /// Bệnh nhân xem danh sách
  Stream<List<Prescription>> streamPrescriptionsByPatient(String patientId) {
    return _collection
        .where("patientId", isEqualTo: patientId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((d) => Prescription.fromDoc(d)).toList());
  }

  /// Bác sĩ xem đơn đã tạo
  Stream<List<Prescription>> streamPrescriptionsByDoctor(String doctorId) {
    return _collection
        .where("doctorId", isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((d) => Prescription.fromDoc(d)).toList());
  }

  /// Chi tiết đơn thuốc
  Future<Prescription?> getPrescription(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Prescription.fromDoc(doc);
  }

  /// QR: kiểm tra đơn thuốc
  Future<Prescription?> verifyPrescriptionFromQR(String qrCodeContent) async {
    final doc = await _collection.doc(qrCodeContent).get();
    if (!doc.exists) return null;
    return Prescription.fromDoc(doc);
  }

  /// Xác nhận đã phát thuốc
  Future<void> markAsDispensed(
      String prescriptionId, String pharmacistId) async {
    await _collection.doc(prescriptionId).update({
      'status': 'dispensed',
      'pharmacistId': pharmacistId,
      'dispensedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

    /// Cập nhật đơn thuốc
  Future<void> updatePrescription(Prescription p) async {
    await _collection.doc(p.prescriptionId).update({
      "prescriptionName": p.prescriptionName,
      "drugs": p.drugs.map((d) => d.toMap()).toList(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

}
