import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/prescription_model.dart';
import '../services/prescription_service.dart';
import 'prescription_detail_screen.dart';

class PrescriptionListScreen extends StatelessWidget {
  final String userId; // Doctor ID hoặc Patient ID
  final String role;   // "doctor" hoặc "patient"

  const PrescriptionListScreen({
    super.key,
    required this.userId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final service = PrescriptionService();

    final Stream<List<Prescription>> stream =
        role == "doctor"
            ? service.streamPrescriptionsByDoctor(userId)
            : service.streamPrescriptionsByPatient(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role == "doctor" ? "Đơn thuốc tôi đã tạo" : "Đơn thuốc của tôi",
        ),
      ),
      body: StreamBuilder<List<Prescription>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có đơn thuốc.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final prescriptions = snapshot.data!;

          return ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final p = prescriptions[index];

              return Card(
                color: Colors.blue.shade50,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),

                  title: Text(
                    p.prescriptionName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text("Chuẩn đoán: ${p.diagnosis}"),
                      const SizedBox(height: 4),
                      Text(
                        "Ngày tạo: ${DateFormat('dd/MM/yyyy – HH:mm').format(p.createdAt)}",
                      ),
                      const SizedBox(height: 4),
                      _buildStatusBadge(p.status),
                    ],
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrescriptionDetailScreen(
                          prescriptionId: p.prescriptionId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// =======================
  /// BADGE TRẠNG THÁI ĐƠN
  /// =======================
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case "pending":
        color = Colors.orange;
        label = "Chờ phát thuốc";
        break;
      case "dispensed":
        color = Colors.green;
        label = "Đã phát thuốc";
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
