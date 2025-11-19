import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  Map<String, dynamic>? patient;
  Map<String, dynamic>? healthNotes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final patientId = ModalRoute.of(context)!.settings.arguments as String;
    _loadPatient(patientId);
    _loadHealthNotes(patientId);
  }

  Future<void> _loadPatient(String patientId) async {
    final snap =
        await FirebaseFirestore.instance.collection("users").doc(patientId).get();
    setState(() {
      patient = snap.data();
    });
  }

  Future<void> _loadHealthNotes(String patientId) async {
    final snap = await FirebaseFirestore.instance
        .collection("patient_health_notes")
        .doc(patientId)
        .get();

    if (snap.exists) {
      setState(() {
        healthNotes = snap.data();
      });
    } else {
      setState(() {
        healthNotes = {
          "conditions": [],
          "allergies": [],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (patient == null || healthNotes == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final diseases = List<String>.from(healthNotes!["conditions"]);
    final allergies = List<String>.from(healthNotes!["allergies"]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Hồ sơ x: ${patient!['displayName']}"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ====== THÔNG TIN CƠ BẢN ======
            Text(
              "Tên: ${patient!['displayName']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text("Số điện thoại: ${patient!['phoneNumber']}"),
            Text("Email: ${patient!['email']}"),
            Text("Địa chỉ: ${patient!['address']}"),
            Text("CCCD: ${patient!['cccd']}"),
            Text("Mã hồ sơ: ${patient!['did']}"),

            const SizedBox(height: 30),

            /// ====== BỆNH NỀN ======
            const Text(
              "Bệnh nền",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (diseases.isEmpty)
              const Text("Không có bệnh nền."),
            if (diseases.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: diseases
                    .map((d) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Text(d),
                            ],
                          ),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 30),

            /// ====== DỊ ỨNG ======
            const Text(
              "Dị ứng",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (allergies.isEmpty)
              const Text("Không có dị ứng."),
            if (allergies.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: allergies
                    .map((a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Text(a),
                            ],
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
