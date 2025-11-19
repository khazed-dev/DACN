import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../health_notes/screens/health_notes_screen.dart';
import '../../treatment_plan/screens/patient_treatment_plan_list_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  final String patientId;

  const PatientHomeScreen({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Trang chủ bệnh nhân",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =============================
            // HEADER THÔNG TIN BỆNH NHÂN
            // =============================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xffE3F2FD),
                    child: Icon(Icons.person, size: 40, color: Color(0xff1E88E5)),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "ID bệnh nhân:\n$patientId",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Chức năng",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // =============================
            // GRID MENU MEDICAL UI
            // =============================
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.15,
              children: [

                // --- Health Notes ---
                _menuCard(
                  context: context,
                  title: "Hồ sơ sức khỏe",
                  icon: Icons.health_and_safety,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HealthNotesScreen(patientId: patientId),
                      ),
                    );
                  },
                ),

                // --- Treatment Plans ---
                _menuCard(
                  context: context,
                  title: "Phác đồ điều trị",
                  icon: Icons.medical_information,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientTreatmentPlanListScreen(
                          patientId: patientId,
                        ),
                      ),
                    );
                  },
                ),

                // --- Prescriptions ---
                _menuCard(
                  context: context,
                  title: "Đơn thuốc & QR",
                  icon: Icons.qr_code_2,
                  color: Colors.deepPurple,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Module 3 đang phát triển...")),
                    );
                  },
                ),

                // --- Appointments ---
                _menuCard(
                  context: context,
                  title: "Lịch tái khám",
                  icon: Icons.calendar_month,
                  color: Colors.orange,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Chức năng sắp ra mắt!")),
                    );
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  // =======================
  // WIDGET MENU CARD
  // =======================
  Widget _menuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
