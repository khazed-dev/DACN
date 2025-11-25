import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/treatment_plan_model.dart';

class TreatmentPlanService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('treatment_plans');

  Future<void> createTreatmentPlan(TreatmentPlan plan) async {
    final docRef = _collection.doc();

    final now = DateTime.now();
    final newPlan = plan.copyWith(
      planId: docRef.id,
      createdAt: now,
      updatedAt: now,
    );

    await docRef.set(newPlan.toMap());
  }

  Stream<List<TreatmentPlan>> getPlansByPatient(String patientId) {
    return _collection
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TreatmentPlan.fromDoc(doc))
          .toList();
    });
  }

  Stream<List<TreatmentPlan>> getPlansByDoctor(String doctorId) {
    return _collection
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TreatmentPlan.fromDoc(doc))
          .toList();
    });
  }

  Future<TreatmentPlan?> getPlan(String planId) async {
    final doc = await _collection.doc(planId).get();
    if (!doc.exists) return null;
    return TreatmentPlan.fromDoc(doc);
  }

  Stream<TreatmentPlan?> watchPlan(String planId) {
    return _collection.doc(planId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TreatmentPlan.fromDoc(doc);
    });
  }

  Future<void> updateTreatmentPlan(TreatmentPlan plan) async {
    final now = DateTime.now();
    final updated = plan.copyWith(updatedAt: now);
    await _collection.doc(plan.planId).update(updated.toMap());
  }
}
