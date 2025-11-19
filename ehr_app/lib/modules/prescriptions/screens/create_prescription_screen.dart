import 'package:flutter/material.dart';
import '../models/medical_drug.dart';
import '../models/prescription_model.dart';
import '../services/prescription_service.dart';

class CreatePrescriptionScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;

  const CreatePrescriptionScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
  });

  @override
  State<CreatePrescriptionScreen> createState() =>
      _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends State<CreatePrescriptionScreen> {
  final TextEditingController _nameController = TextEditingController();

  List<MedicalDrug> drugs = [];

  Future<void> _submit() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nhập tên đơn thuốc")),
      );
      return;
    }

    if (drugs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thêm ít nhất 1 thuốc")),
      );
      return;
    }

    // model chuẩn
    final prescription = Prescription(
      prescriptionId: "",       // sẽ ghi đè bằng docRef.id
      prescriptionName: _nameController.text,
      doctorId: widget.doctorId,
      patientId: widget.patientId,
      drugs: drugs,
      status: "pending",
      createdAt: DateTime.now(),
      updatedAt: null,
      qrCode: "",               // sẽ ghi đè bằng docRef.id
      pharmacistId: null,
      dispensedAt: null,
    );

    await PrescriptionService().createPrescription(prescription);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✔ Tạo đơn thuốc thành công")),
    );

    Navigator.pop(context);
  }

  void _addDrug() {
    drugs.add(
      MedicalDrug(
        name: "Thuốc mới",
        dosage: "500mg",
        instructions: "Sáng 1 viên",
        duration: 5,
        morning: true,
        noon: false,
        evening: false,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo đơn thuốc"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDrug,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text("Tên đơn thuốc"),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: drugs.length,
                itemBuilder: (context, index) {
                  final d = drugs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${d.name} – ${d.dosage}"),
                      subtitle: Text(d.instructions),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          drugs.removeAt(index);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("Lưu đơn thuốc"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
