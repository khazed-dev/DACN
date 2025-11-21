import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'prescription_detail_screen.dart';

class PatientPrescriptionListScreen extends StatelessWidget {
  final String patientId;

  const PatientPrescriptionListScreen({super.key, required this.patientId});

  String formatTimestamp(Timestamp ts) {
    final date = ts.toDate();
    return "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F3FA), // pastel nhẹ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Đơn thuốc của tôi",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("prescriptions")
            .where("patientId", isEqualTo: patientId)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "Bạn chưa có đơn thuốc nào.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;

              final Timestamp ts = data["createdAt"];
              final String formattedDate = formatTimestamp(ts);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PrescriptionDetailScreen(prescriptionId: docs[i].id),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon thuốc
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xffEDE7F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.medication, // icon thuốc
                          size: 32,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Nội dung chính
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Đơn thuốc #${docs[i].id.substring(0, 6)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Ngày kê: $formattedDate",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Lấy tên bác sĩ (doctorId -> users)
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(data["doctorId"])
                                  .get(),
                              builder: (context, doctorSnap) {
                                if (!doctorSnap.hasData) {
                                  return const Text(
                                    "Bác sĩ: ...",
                                    style: TextStyle(fontSize: 14),
                                  );
                                }

                                final doctor = doctorSnap.data!.data()
                                    as Map<String, dynamic>;

                                return Text(
                                  "Bác sĩ: ${doctor["displayName"] ?? "Không rõ"}",
                                  style: const TextStyle(fontSize: 14),
                                );
                              },
                            ),
                          ],
                        ),
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
