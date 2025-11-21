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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Nhập tên đơn thuốc")));
      return;
    }

    if (drugs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Thêm ít nhất 1 thuốc")));
      return;
    }

    final prescription = Prescription(
      prescriptionId: "",
      prescriptionName: _nameController.text,
      doctorId: widget.doctorId,
      patientId: widget.patientId,
      drugs: drugs,
      status: "pending",
      createdAt: DateTime.now(),
      updatedAt: null,
      qrCode: "",
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
    showDialog(
      context: context,
      builder: (context) {
        final nameCtrl = TextEditingController();
        final dosageCtrl = TextEditingController();
        final instrCtrl = TextEditingController();

        bool morning = false, noon = false, evening = false;

        return StatefulBuilder(
          builder: (context, setPopupState) {
            return AlertDialog(
              title: const Text("Thêm thuốc"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Tên thuốc"),
                  ),
                  TextField(
                    controller: dosageCtrl,
                    decoration: const InputDecoration(labelText: "Liều lượng"),
                  ),
                  TextField(
                    controller: instrCtrl,
                    decoration: const InputDecoration(labelText: "Hướng dẫn"),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: morning,
                        onChanged: (v) => setPopupState(() => morning = v!),
                      ),
                      const Text("Sáng"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: noon,
                        onChanged: (v) => setPopupState(() => noon = v!),
                      ),
                      const Text("Trưa"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: evening,
                        onChanged: (v) => setPopupState(() => evening = v!),
                      ),
                      const Text("Tối"),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Huỷ"),
                ),
                ElevatedButton(
                  onPressed: () {
                    drugs.add(
                      MedicalDrug(
                        name: nameCtrl.text,
                        dosage: dosageCtrl.text,
                        instructions: instrCtrl.text,
                        duration: 5,
                        morning: morning,
                        noon: noon,
                        evening: evening,
                      ),
                    );
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text("Thêm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo đơn thuốc")),
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
                      subtitle: Text("${d.instructions}"),
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
            ),
          ],
        ),
      ),
    );
  }
}
