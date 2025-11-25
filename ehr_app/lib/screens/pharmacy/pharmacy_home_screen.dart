import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pharmacy_scan_screen.dart';
import 'pharmacy_history_screen.dart';
import 'pharmacy_verify_screen.dart';

class PharmacyHomeScreen extends StatelessWidget {
  final String pharmacistId;

  const PharmacyHomeScreen({super.key, required this.pharmacistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F2FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Nhà thuốc",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _menuButton(
              icon: Icons.qr_code_scanner,
              label: "Quét QR đơn thuốc",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PharmacyScanScreen(pharmacistId: pharmacistId),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _menuButton(
              icon: Icons.keyboard,
              label: "Nhập ID đơn thuốc",
              onTap: () {
                _showManualInputDialog(context, pharmacistId);
              },
            ),

            const SizedBox(height: 16),

            _menuButton(
              icon: Icons.history,
              label: "Lịch sử cấp phát",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PharmacyHistoryScreen(pharmacistId: pharmacistId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================
  // MENU BUTTON WIDGET
  // ===========================
  Widget _menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xffEEE0FF),
              child: Icon(icon, color: Colors.deepPurple, size: 26),
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  // ===========================
  // MANUAL INPUT DIALOG
  // ===========================
  void _showManualInputDialog(BuildContext context, String pharmacistId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Nhập ID đơn thuốc"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Prescription ID",
              hintText: "Nhập ID...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                final id = controller.text.trim();
                if (id.isEmpty) return;

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PharmacyVerifyScreen(
                      prescriptionId: id,
                      pharmacistId: pharmacistId,
                    ),
                  ),
                );
              },
              child: const Text("Xác nhận"),
            ),
          ],
        );
      },
    );
  }
}
