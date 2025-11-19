import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prescription_model.dart';
import '../services/prescription_service.dart';

class DoctorPrescriptionListScreen extends StatelessWidget {
  final String doctorId;

  const DoctorPrescriptionListScreen({
    super.key,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đơn thuốc đã tạo"),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.add),
        label: const Text("Tạo đơn thuốc"),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/doctor/prescription/create",
            arguments: doctorId,
          );
        },
      ),

      body: StreamBuilder<List<Prescription>>(
        stream: PrescriptionService()
            .streamPrescriptionsByDoctor(doctorId),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final prescriptions = snapshot.data ?? [];

          if (prescriptions.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có đơn thuốc nào.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: prescriptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final p = prescriptions[index];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/patient/prescription/detail",
                    arguments: p.prescriptionId,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.prescriptionName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Bệnh nhân: ${p.patientId}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      Text(
                        "Trạng thái: ${p.status}",
                        style: TextStyle(
                          color: p.status == "dispensed"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Ngày tạo: ${p.createdAt.toLocal()}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
