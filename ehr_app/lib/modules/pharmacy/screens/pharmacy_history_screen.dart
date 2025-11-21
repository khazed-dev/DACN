import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyHistoryScreen extends StatelessWidget {
  final String pharmacistId;

  const PharmacyHistoryScreen({super.key, required this.pharmacistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lịch sử cấp phát thuốc")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("prescriptions")
            .where("pharmacistId", isEqualTo: pharmacistId)
            .where("status", isEqualTo: "dispensed")
            .orderBy("dispensedAt", descending: true)
            .snapshots(),

        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("Chưa có lịch sử cấp phát."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final ts = data["dispensedAt"] as Timestamp;
              final time = ts.toDate();

              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đơn #${docs[index].id.substring(0, 6)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),
                    Text("Bệnh nhân ID: ${data["patientId"]}"),
                    Text("Ngày cấp: ${time.day}/${time.month}/${time.year} "
                        "${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
