import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/prescription_service.dart';
import 'pharmacy_confirm_screen.dart';

class PharmacyScanScreen extends StatefulWidget {
  const PharmacyScanScreen({super.key});

  @override
  State<PharmacyScanScreen> createState() => _PharmacyScanScreenState();
}

class _PharmacyScanScreenState extends State<PharmacyScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;

    ctrl.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;

      setState(() => isProcessing = true);

      final qrText = scanData.code;

      if (qrText == null || qrText.isEmpty) {
        _showError("QR không hợp lệ");
        return;
      }

      print("📌 QR scanned: $qrText");

      // Kiểm tra đơn thuốc tồn tại
      final prescription = await PrescriptionService()
          .verifyPrescriptionFromQR(qrText);

      if (prescription == null) {
        _showError("Không tìm thấy đơn thuốc trong hệ thống!");
        return;
      }

      // Chuyển sang màn xác nhận
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PharmacyConfirmScreen(
            prescription: prescription,
          ),
        ),
      ).then((_) {
        // Quay lại tiếp tục quét QR
        setState(() => isProcessing = false);
        controller!.resumeCamera();
      });
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
    setState(() => isProcessing = false);
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quét QR Đơn Thuốc"),
      ),

      body: Stack(
        children: [
          // Camera
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),

          // Overlay khung quét
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Hướng dẫn
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  "Đưa mã QR vào trong khung",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Icon(Icons.qr_code_scanner,
                    color: Colors.white, size: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
