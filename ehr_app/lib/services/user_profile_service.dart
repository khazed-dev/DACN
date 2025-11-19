import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> ensureUserProfile() async {
    final uid = _auth.currentUser!.uid;
    final userRef = _db.collection('users').doc(uid);

    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        "uid": uid,
        "did": uid, // Tạm thời dùng uid làm DID (lúc này rule vẫn chấp nhận)
        "role": "patient",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }
}
