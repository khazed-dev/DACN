import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/prescription_model.dart';
import '../../services/prescription_service.dart';

class PharmacyConfirmScreen extends StatefulWidget {
  final Prescription prescription;

  const PharmacyConfirmScreen({
    super.key,
    required this.prescription,
  });

  @override
  State<PharmacyConfirmScreen> createState() => _PharmacyConfirmScreenState();
}

class _PharmacyConfirmScreenState extends State<PharmacyConfirmScreen> {
  bool isLoading = false;

  Future<void> confirmDispense() async {
    setState(() => isLoading = true);

    final prescriptionId = widget.prescription.prescriptionId;

    // ⚠️ Sau này bạn thay bằng FirebaseAuth.currentUser!.uid
    final pharmacistId = "pharmacy_staff_001";

    await PrescriptionService().markAsDispensed(
      prescriptionId,
      pharmacistId,
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✔ Đã xác nhận phát thuốc thành công"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prescription;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận đơn thuốc"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ============================
            // THÔNG TIN ĐƠN THUỐC
            // ============================
            Text(
              p.prescriptionName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("👤 Bệnh nhân: ${p.patientId}",
                style: const TextStyle(fontSize: 16)),
            Text("🩺 Bác sĩ: ${p.doctorId}",
                style: const TextStyle(fontSize: 16)),
            Text(
              "📅 Ngày tạo: ${p.createdAt.toLocal()}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "📌 Trạng thái: ${p.status}",
              style: TextStyle(
                fontSize: 16,
                color: p.status == "dispensed" ? Colors.green : Colors.orange,
              ),
            ),

            const Divider(height: 30),

            // ============================
            // LIST THUỐC
            // ============================
            const Text(
              "Danh sách thuốc",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: p.drugs.length,
                itemBuilder: (context, index) {
                  final drug = p.drugs[index];

                  // FORMAT BUỔI UỐNG
                  String times = [
                    if (drug.morning) "Sáng",
                    if (drug.noon) "Trưa",
                    if (drug.evening) "Tối",
                  ].join(" • ");

                  return Card(
                    child: ListTile(
                      title: Text(
                        "${drug.name} (${drug.dosage})",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(drug.instructions),
                          if (times.isNotEmpty)
                            Text("🕒 Uống: $times"),
                        ],
                      ),
                      trailing: Text(
                        "${drug.duration} ngày",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ============================
            // BUTTON CONFIRM
            // ============================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Xác nhận đã phát thuốc"),
                onPressed: isLoading ? null : confirmDispense,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
