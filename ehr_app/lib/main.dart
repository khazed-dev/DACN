import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'modules/auth/screens/auth_gate.dart';

// MODULE 1
import 'modules/health_notes/screens/edit_health_notes_screen.dart';

// MODULE 2
import 'modules/treatment_plan/screens/treatment_plan_list_screen.dart';
import 'modules/treatment_plan/screens/create_treatment_plan_screen.dart';
import 'modules/treatment_plan/screens/treatment_plan_detail_screen.dart';

// PHARMACY
import 'modules/prescriptions/screens/pharmacy_scan_screen.dart';

// PATIENT
import 'modules/patient/screens/patient_details_screen.dart';
import 'modules/patient/screens/patient_home_screen.dart';

// DOCTOR
import 'modules/doctor/screens/doctor_patient_details_screen.dart';
import 'modules/doctor/screens/doctor_home_screen.dart';
import 'modules/prescriptions/screens/doctor_prescription_list_screen.dart';
import 'modules/prescriptions/screens/create_prescription_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        // MODULE 1
        "/health-notes": (_) => const EditHealthNotesScreen(),

        // DOCTOR
        "/doctor/patient-details": (_) => const DoctorPatientDetailsScreen(),

        "/doctor/prescriptions": (context) {
          final doctorId = ModalRoute.of(context)!.settings.arguments as String;
          return DoctorPrescriptionListScreen(doctorId: doctorId);
        },

        "/doctor/prescription/create": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return CreatePrescriptionScreen(
            doctorId: args["doctorId"],
            patientId: args["patientId"],
          );
        },

        // PHARMACY
        "/pharmacy/scan": (_) => const PharmacyScanScreen(),

        // PATIENT
        "/patient/home": (context) {
          final patientId = ModalRoute.of(context)!.settings.arguments as String;
          return PatientHomeScreen(patientId: patientId);
        },
        "/patient/details": (_) => const PatientDetailsScreen(),
      },

      home: const AuthGate(),
    );
  }
}
