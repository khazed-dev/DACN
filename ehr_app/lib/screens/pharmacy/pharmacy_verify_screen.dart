import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyVerifyScreen extends StatelessWidget {
  final String prescriptionId;
  final String pharmacistId;

  const PharmacyVerifyScreen({
    super.key,
    required this.prescriptionId,
    required this.pharmacistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác minh đơn thuốc"),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("prescriptions")
            .doc(prescriptionId.trim())
            .get(),

        builder: (context, snap) {

          // ⏳ LOADING
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ FIREBASE ERROR (permission denied, network error…)
          if (snap.hasError) {
            return Center(
              child: Text(
                "Lỗi khi tải đơn thuốc:\n${snap.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // ❌ KHÔNG NHẬN ĐƯỢC DATA
          if (!snap.hasData) {
            return const Center(
              child: Text("Không nhận được dữ liệu từ Firestore"),
            );
          }

          // ❌ DOCUMENT KHÔNG TỒN TẠI
          if (!snap.data!.exists) {
            return Center(
              child: Text(
                "❌ Không tìm thấy đơn thuốc\nID: $prescriptionId",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          // ✔ LẤY DATA
          final data = snap.data!.data() as Map<String, dynamic>;
          final List drugs = data["drugs"] ?? [];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Mã đơn: $prescriptionId",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Text("Bệnh nhân ID: ${data["patientId"]}"),
                Text("Trạng thái hiện tại: ${data["status"]}"),

                const SizedBox(height: 20),

                const Text(
                  "Danh sách thuốc",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    children: drugs.map((d) => _drugItem(d)).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // NÚT XÁC MINH
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

                      try {
                        await FirebaseFirestore.instance
                            .collection("prescriptions")
                            .doc(prescriptionId)
                            .update({
                          "status": "dispensed",
                          "pharmacistId": pharmacistId,
                          "dispensedAt": Timestamp.now(),
                        });

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Đã xác minh & cấp phát thuốc"),
                            ),
                          );
                          Navigator.pop(context);
                        }

                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Lỗi cập nhật: $e")),
                          );
                        }
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "XÁC MINH & CẤP THUỐC",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drugItem(Map drug) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 7,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${drug["name"]} (${drug["dosage"]})",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text("Thời gian dùng: ${drug["duration"]} ngày"),
          Text("Sáng: ${drug["morning"] == true ? "✔" : "✘"}"),
          Text("Trưa: ${drug["noon"] == true ? "✔" : "✘"}"),
          Text("Tối: ${drug["evening"] == true ? "✔" : "✘"}"),
          if (drug["instructions"] != null)
            Text("Hướng dẫn: ${drug["instructions"]}"),
        ],
      ),
    );
  }
}
