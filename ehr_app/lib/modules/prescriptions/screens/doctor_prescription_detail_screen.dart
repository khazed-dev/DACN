import 'package:flutter/material.dart';
import '../models/prescription_model.dart';

class DoctorPrescriptionDetailScreen extends StatelessWidget {
  final Prescription prescription;

  const DoctorPrescriptionDetailScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết đơn thuốc")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tên đơn thuốc: ${prescription.prescriptionName}",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            Text("Mã đơn: ${prescription.prescriptionId}"),

            const SizedBox(height: 20),
            const Text("Danh sách thuốc:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: prescription.drugs.length,
                itemBuilder: (context, index) {
                  final d = prescription.drugs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${d.name} – ${d.dosage}"),
                      subtitle: Text(d.instructions),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
