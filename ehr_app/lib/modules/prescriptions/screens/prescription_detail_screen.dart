import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final String prescriptionId;

  const PrescriptionDetailScreen({super.key, required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết đơn thuốc")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("prescriptions")
            .doc(prescriptionId)
            .get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!.data() as Map<String, dynamic>;

          final List drugs = data["drugs"] ?? [];
          final Timestamp ts = data["createdAt"];
          final DateTime date = ts.toDate();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===============================
                // BÁC SĨ KÊ ĐƠN
                // ===============================
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(data["doctorId"])
                      .get(),
                  builder: (context, doctorSnap) {
                    if (!doctorSnap.hasData) {
                      return const Text(
                        "Bác sĩ kê đơn: ...",
                        style: TextStyle(fontSize: 18),
                      );
                    }

                    final doctor =
                        doctorSnap.data!.data() as Map<String, dynamic>;
                    return Text(
                      "Bác sĩ kê đơn: ${doctor["displayName"] ?? "Không rõ"}",
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // ===============================
                // NGÀY KÊ ĐƠN
                // ===============================
                Text(
                  "Ngày kê: ${date.day}/${date.month}/${date.year}  "
                  "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                // ===============================
                // DANH SÁCH THUỐC
                // ===============================
                const Text(
                  "Danh sách thuốc",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ...drugs.map((drug) => _drugCard(drug)).toList(),

                const SizedBox(height: 30),

                // ===============================
                // QR XÁC MINH
                // ===============================
                const Text(
                  "QR Xác minh đơn thuốc",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: QrImageView(
                    data: prescriptionId,
                    version: QrVersions.auto,
                    size: 220,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =======================================================
  // HIỂN THỊ 1 LOẠI THUỐC CHI TIẾT ĐẸP – CHUẨN Y TẾ
  // =======================================================
  Widget _drugCard(Map drug) {
    // Build uống sáng – trưa – tối
    List<String> times = [];
    if (drug["morning"] == true) times.add("sáng");
    if (drug["noon"] == true) times.add("trưa");
    if (drug["evening"] == true) times.add("tối");

    final frequency = times.isEmpty ? "Không rõ" : times.join(" • ");

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Tên thuốc + hàm lượng
          Text(
            "${drug["name"]} (${drug["dosage"]})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // Số ngày sử dụng
          if (drug["duration"] != null)
            Text(
              "Thời gian sử dụng: ${drug["duration"]} ngày",
              style: const TextStyle(fontSize: 15),
            ),

          const SizedBox(height: 4),

          // Uống sáng – trưa – tối
          Text(
            "Uống: $frequency",
            style: const TextStyle(fontSize: 15),
          ),

          const SizedBox(height: 4),

          // Hướng dẫn sử dụng
          if (drug["instructions"] != null &&
              drug["instructions"].toString().trim().isNotEmpty)
            Text(
              "Hướng dẫn: ${drug["instructions"]}",
              style: const TextStyle(fontSize: 15),
            ),
        ],
      ),
    );
  }
}
