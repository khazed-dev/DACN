import 'package:flutter/material.dart';
import '../../models/prescription_model.dart';
import '../../services/prescription_service.dart';

class DoctorPrescriptionListScreen extends StatelessWidget {
  final String doctorId;
  final String patientId;

  const DoctorPrescriptionListScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đơn thuốc đã tạo")),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.add),
        label: const Text("Tạo đơn thuốc"),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/doctor/prescription/create",
            arguments: {
              "doctorId": doctorId,
              "patientId": patientId,
            },
          );
        },
      ),

      body: StreamBuilder<List<Prescription>>(
        stream: PrescriptionService().streamPrescriptionsByDoctor(doctorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final prescriptions = snapshot.data ?? [];

          if (prescriptions.isEmpty) {
            return const Center(child: Text("Chưa có đơn thuốc nào."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final p = prescriptions[index];

              return Card(
                child: ListTile(
                  title: Text(p.prescriptionName),
                  subtitle: Text("Bệnh nhân ID: ${p.patientId}"),
                  
                  // 👉 Nhấn vào sẽ xem chi tiết đơn thuốc
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/doctor/prescription/detail",
                      arguments: p.prescriptionId,
                    );
                  },

                  // 👉 Hai nút hành động
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // NÚT EDIT
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/doctor/prescription/edit",
                              arguments: {"prescriptionId": p.prescriptionId},
                            );
                          },
                        ),


                      // NÚT XOÁ
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text("Xoá đơn thuốc?"),
                                  content: Text("Bạn chắc chắn muốn xoá '${p.prescriptionName}'?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                      child: const Text("Huỷ"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await PrescriptionService().deletePrescription(p.prescriptionId);
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                      child: const Text("Xoá"),
                                    ),
                                  ],
                                ),
                              );
                            },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
