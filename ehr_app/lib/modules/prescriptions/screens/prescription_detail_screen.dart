import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/prescription_model.dart';
import '../services/prescription_service.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  final String prescriptionId;

  const PrescriptionDetailScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  State<PrescriptionDetailScreen> createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  final _service = PrescriptionService();

  Prescription? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _service.getPrescription(widget.prescriptionId);

    setState(() {
      _data = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn thuốc"),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? const Center(child: Text("Không tìm thấy đơn thuốc"))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final p = _data!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===========================
          // THÔNG TIN CHUNG
          // ===========================
          Text(
            "Mã đơn thuốc: ${p.id}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),
          Text("Chuẩn đoán: ${p.diagnosis}"),
          Text("Bác sĩ ID: ${p.doctorId}"),
          Text("Bệnh nhân ID: ${p.patientId}"),
          const SizedBox(height: 8),

          _buildStatusChip(p.status),

          const SizedBox(height: 20),

          // ===========================
          // DANH SÁCH THUỐC
          // ===========================
          const Text(
            "Danh sách thuốc",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...p.drugs.map(_buildDrugItem),

          const SizedBox(height: 30),

          // ===========================
          // QR CODE
          // ===========================
          Center(
            child: Column(
              children: [
                const Text(
                  "QR xác minh đơn thuốc",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                QrImageView(
                  data: p.qrCode,
                  size: 180,
                  backgroundColor: Colors.white,
                ),

                const SizedBox(height: 8),
                Text(
                  "Quét QR tại nhà thuốc để nhận thuốc",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===========================
  // 1 thuốc trong danh sách
  // ===========================
  Widget _buildDrugItem(MedicalDrug drug) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            drug.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text("Liều lượng: ${drug.dosage}"),
          Text("Hướng dẫn: ${drug.instructions}"),
        ],
      ),
    );
  }

  // ===========================
  // CHIP TRẠNG THÁI
  // ===========================
  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case "pending":
        color = Colors.orange;
        label = "Chưa phát thuốc";
        break;
      case "dispensed":
        color = Colors.green;
        label = "Đã phát thuốc";
        break;
      default:
        color = Colors.grey;
        label = "Không xác định";
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrescriptionQRScreen(
          prescriptionId: p.id,
          qrData: p.qrCode,
        ),
      ),
    );
  },
  child: const Text("Xem QR"),
)

}
