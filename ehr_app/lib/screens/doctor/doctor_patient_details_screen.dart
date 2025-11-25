import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPatientDetailsScreen extends StatefulWidget {
  const DoctorPatientDetailsScreen({super.key});

  @override
  State<DoctorPatientDetailsScreen> createState() =>
      _DoctorPatientDetailsScreenState();
}

class _DoctorPatientDetailsScreenState
    extends State<DoctorPatientDetailsScreen> {
  Map<String, dynamic>? patient;
  Map<String, dynamic>? healthNotes;

  late String patientId;
  late String doctorId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    patientId = args["patientId"];
    doctorId = args["doctorId"];

    _loadPatient(patientId);
    _loadHealthNotes(patientId);
  }

  Future<void> _loadPatient(String id) async {
    final snap =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (!snap.exists) return;

    setState(() {
      patient = snap.data();
    });
  }

  Future<void> _loadHealthNotes(String patientId) async {
    final snap = await FirebaseFirestore.instance
        .collection("patient_health_notes")
        .doc(patientId)
        .get();

    if (!snap.exists) {
      setState(() {
        healthNotes = {"conditions": [], "allergies": []};
      });
      return;
    }

    final data = snap.data()!;
    setState(() {
      healthNotes = {
        "conditions": List<String>.from(data["conditions"] ?? []),
        "allergies": List<String>.from(data["allergies"] ?? []),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patient == null || healthNotes == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final diseases = healthNotes!["conditions"] as List<String>;
    final allergies = healthNotes!["allergies"] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text("Hồ sơ bệnh nhân: ${patient!['displayName']}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tên: ${patient!['displayName']}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Số điện thoại: ${patient!['phoneNumber']}"),
            Text("Email: ${patient!['email']}"),
            Text("Địa chỉ: ${patient!['address']}"),
            Text("CCCD: ${patient!['cccd']}"),
            Text("Mã hồ sơ: ${patient!['did']}"),

            const SizedBox(height: 30),

            const Text("Bệnh nền",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...diseases.map((d) => Text("- $d")).toList(),

            const SizedBox(height: 30),

            const Text("Dị ứng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...allergies.map((a) => Text("- $a")).toList(),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/doctor/treatment-plans",
                  arguments: {"patientId": patientId},
                );
              },
              child: const Text("Phác đồ điều trị"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/doctor/prescriptions",
                  arguments: {
                    "doctorId": doctorId,
                    "patientId": patientId,
                  },
                );
              },
              child: const Text("Đơn thuốc"),
            ),
          ],
        ),
      ),
    );
  }
}
