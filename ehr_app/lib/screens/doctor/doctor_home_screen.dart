import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorHomeScreen extends StatefulWidget {
  final String doctorId;

  const DoctorHomeScreen({super.key, required this.doctorId});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  String? specialization;
  String? hospital;

  @override
  void initState() {
    super.initState();
    _loadDoctorInfo();
  }

  Future<void> _loadDoctorInfo() async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.doctorId)
        .get();

    final data = snap.data()!;
    specialization = data["specialization"];
    hospital = data["hospitalName"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /// Chưa load xong thông tin bác sĩ → loading
    if (specialization == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Doctor Dashboard"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, size: 22),
              tooltip: "Đăng xuất",
              onPressed: () async {
                // Xác nhận đăng xuất
                final confirm = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Đăng xuất"),
                      content: const Text("Bạn có chắc muốn đăng xuất không?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Đăng xuất"),
                        ),
                      ],
                    );
                  },
                );

                if (confirm != true) return;

                // Thực hiện đăng xuất Firebase
                await FirebaseAuth.instance.signOut();

                // Quay về màn hình login
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/",
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// THÔNG TIN BÁC SĨ
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Khoa: $specialization",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          /// DANH SÁCH BỆNH NHÂN
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "patient")
                  .where("doctorId", isEqualTo: widget.doctorId) // 🔥 LẤY DS BỆNH NHÂN CỦA BÁC SĨ
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final patients = snap.data!.docs;

                if (patients.isEmpty) {
                  return const Center(
                    child: Text("Không có bệnh nhân nào thuộc quản lý của bạn."),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final p = patients[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/doctor/patient-details",
                            arguments: {
                              "patientId": patients[index].id,
                              "doctorId": widget.doctorId,
                            },
                          );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              child: Text(p["displayName"][0]),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p["displayName"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Mã hồ sơ: ${p["did"]}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
