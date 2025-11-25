import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pharmacy_verify_screen.dart';

class PharmacyScanScreen extends StatefulWidget {
  final String pharmacistId;

  const PharmacyScanScreen({super.key, required this.pharmacistId});

  @override
  State<PharmacyScanScreen> createState() => _PharmacyScanScreenState();
}

class _PharmacyScanScreenState extends State<PharmacyScanScreen> {
  bool _scanned = false; // tránh quét nhiều lần

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quét QR đơn thuốc"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // CAMERA
          MobileScanner(
            onDetect: (capture) async {
              if (_scanned) return;
              _scanned = true;

              final code = capture.barcodes.first.rawValue;
              if (code == null) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PharmacyVerifyScreen(
                    prescriptionId: code,
                    pharmacistId: widget.pharmacistId,
                  ),
                ),
              ).then((_) => _scanned = false);
            },
          ),

          // Khung quét
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                "Đưa mã QR vào khung để quét",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(offset: Offset(1, 1), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
