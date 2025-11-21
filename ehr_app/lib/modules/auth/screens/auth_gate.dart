import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import '../../patient/screens/patient_home_screen.dart';
import '../../doctor/screens/doctor_home_screen.dart';
import '../../pharmacy/screens/pharmacy_home_screen.dart';



class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Chưa đăng nhập → về Login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final uid = snapshot.data!.uid;

        // Lấy thông tin người dùng từ Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snap.data!.exists) {
              return const Scaffold(
                body: Center(child: Text("User không tồn tại trong Firestore")),
              );
            }

            final userData = snap.data!.data() as Map<String, dynamic>;
            final role = userData['role'];

            // Điều hướng theo role
            if (role == 'doctor') {
              return DoctorHomeScreen(doctorId: uid);
            } 
            else if (role == 'pharmacist') {
              return PharmacyHomeScreen(pharmacistId: uid);
            } 
            else {
              return PatientHomeScreen(patientId: uid);
            }
          },
        );
      },
    );
  }
}
