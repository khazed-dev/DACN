import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/health_notes_model.dart';

class HealthNotesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ĐÚNG COLLECTION THEO RULE
  CollectionReference get col =>
      _db.collection("patient_health_notes");

  // Lưu / tạo mới
  Future<void> saveHealthNotes(HealthNotes notes) async {
    await col.doc(notes.userId).set(
      notes.toMap(),
      SetOptions(merge: true),
    );
  }

  // Lấy notes theo UID login
  Future<HealthNotes?> getHealthNotes() async {
    final uid = _auth.currentUser!.uid;

    final doc = await col.doc(uid).get();

    if (!doc.exists) return null;

    return HealthNotes.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Cập nhật note
  Future<void> updateHealthNotes(HealthNotes notes) async {
    await col.doc(notes.userId).set(
      notes.toMap(),
      SetOptions(merge: true),
    );
  }
}
