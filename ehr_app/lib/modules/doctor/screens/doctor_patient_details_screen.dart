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

    final args = ModalRoute.of(context)!.settings.arguments as Map?;

    if (args == null || !args.containsKey("patientId") || !args.containsKey("doctorId")) {
      print("❌ ERROR: Missing arguments for DoctorPatientDetailsScreen");
      return;
    }

    patientId = args["patientId"];
    doctorId = args["doctorId"];

    print("🔥 RECEIVED → patientId = $patientId , doctorId = $doctorId");

    _loadPatient(patientId);
    _loadHealthNotes(patientId);
  }

  // ===== LOAD THÔNG TIN BỆNH NHÂN =====
  Future<void> _loadPatient(String id) async {
    final snap =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (!snap.exists) {
      print("❌ Không tìm thấy patient trong 'users'");
      return;
    }

    setState(() {
      patient = snap.data();
    });
  }

  // ===== LOAD THÔNG TIN BỆNH NỀN + DỊ ỨNG =====
  Future<void> _loadHealthNotes(String patientId) async {
    try {
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
    } catch (e) {
      print("❌ ERROR in _loadHealthNotes: $e");
    }
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
              "Bệnh nền (bác sĩ cập nhật)",
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

            const SizedBox(height: 40),

            // =========================
            // NÚT PHÁC ĐỒ + ĐƠN THUỐC
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // --- Nút Phác đồ điều trị ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.medical_services_outlined,
                          color: Colors.purple),
                      label: const Text("Phác đồ điều trị",
                          style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/doctor/treatment-plans",
                          arguments: patientId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade50,
                        foregroundColor: Colors.purple.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Nút Đơn thuốc ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon:
                          const Icon(Icons.receipt_long, color: Colors.blue),
                      label: const Text("Đơn thuốc",
                          style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/doctor/prescriptions",
                          arguments: doctorId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
