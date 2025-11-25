import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_gate.dart';

// SCREENS - AUTH
import 'screens/auth/login_screen.dart';

// SCREENS - HEALTH NOTES
import 'screens/patient/edit_health_notes_screen.dart';

// SCREENS - TREATMENT PLANS
import 'screens/doctor/treatment_plan_list_screen.dart';
import 'screens/doctor/create_treatment_plan_screen.dart';
import 'screens/doctor/treatment_plan_detail_screen.dart';
import 'screens/patient/patient_treatment_plan_list_screen.dart';

// SCREENS - PHARMACY
import 'screens/pharmacy/pharmacy_scan_screen.dart';
import 'screens/pharmacy/pharmacy_verify_screen.dart';
import 'screens/pharmacy/pharmacy_home_screen.dart';
import 'screens/pharmacy/pharmacy_history_screen.dart';

// SCREENS - PATIENT
import 'screens/patient/patient_details_screen.dart';
import 'screens/patient/patient_home_screen.dart';

// SCREENS - DOCTOR
import 'screens/doctor/doctor_patient_details_screen.dart';
import 'screens/doctor/doctor_prescription_list_screen.dart';
import 'screens/doctor/create_prescription_screen.dart';
import 'screens/common/prescription_detail_screen.dart';
import 'screens/doctor/edit_prescription_screen.dart';

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

        // DOCTOR ROUTES
        "/doctor/patient-details": (_) => const DoctorPatientDetailsScreen(),

        "/doctor/prescriptions": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return DoctorPrescriptionListScreen(
            doctorId: args["doctorId"],
            patientId: args["patientId"],
          );
        },

        "/doctor/prescription/create": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return CreatePrescriptionScreen(
            doctorId: args["doctorId"],
            patientId: args["patientId"],
          );
        },

        "/doctor/prescription/detail": (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String;
          return PrescriptionDetailScreen(prescriptionId: id);
        },

        "/doctor/treatment-plans": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return TreatmentPlanListScreen(patientId: args["patientId"]);
        },

        "/doctor/prescription/edit": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return EditPrescriptionScreen(
            prescriptionId: args["prescriptionId"],
          );
        },

        // PHARMACY
        "/pharmacy/home": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return PharmacyHomeScreen(pharmacistId: args["pharmacistId"]);
        },

        "/pharmacy/scan": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return PharmacyScanScreen(pharmacistId: args["pharmacistId"]);
        },
        "/pharmacy/history": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return PharmacyHistoryScreen(pharmacistId: args["pharmacistId"]);
        },

        // PATIENT
        "/patient/details": (_) => const PatientDetailsScreen(),
      },

      home: const AuthGate(),
    );
  }
}
