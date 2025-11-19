import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PrescriptionQRScreen extends StatelessWidget {
  final String prescriptionId;
  final String qrData;

  const PrescriptionQRScreen({
    super.key,
    required this.prescriptionId,
    required this.qrData,
  });

  Future<void> _saveQRImage(BuildContext context) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: qrData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      if (qrValidationResult.status != QrValidationStatus.valid) {
        throw Exception("QR không hợp lệ");
      }

      final qrCode = qrValidationResult.qrCode!;
      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );

      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/qr_${prescriptionId}.png");

      ByteData? data =
          await painter.toImageData(300); // 300px -> đủ sắc nét để quét
      final bytes = data!.buffer.asUint8List();

      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã lưu QR vào: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể lưu QR: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Đơn Thuốc"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // =============================
            // QR hiển thị lớn
            // =============================
            Expanded(
              child: Center(
                child: QrImageView(
                  data: qrData,
                  size: 280,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // Prescription ID
            // =============================
            Text(
              "Prescription ID:",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              prescriptionId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // NÚT COPY ID
            // =============================
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: prescriptionId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã copy Prescription ID")),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text("Copy Prescription ID"),
            ),

            const SizedBox(height: 12),

            // =============================
            // NÚT TẢI ẢNH QR
            // =============================
            ElevatedButton.icon(
              onPressed: () => _saveQRImage(context),
              icon: const Icon(Icons.download),
              label: const Text("Tải QR về máy"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
