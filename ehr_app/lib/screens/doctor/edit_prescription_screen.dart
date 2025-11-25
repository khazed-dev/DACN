import 'package:flutter/material.dart';
import '../../models/prescription_model.dart';
import '../../models/medical_drug.dart';
import '../../services/prescription_service.dart';

class EditPrescriptionScreen extends StatefulWidget {
  final String prescriptionId;

  const EditPrescriptionScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  State<EditPrescriptionScreen> createState() =>
      _EditPrescriptionScreenState();
}

class _EditPrescriptionScreenState extends State<EditPrescriptionScreen> {
  final _service = PrescriptionService();

  Prescription? _data;
  bool _loading = true;

  final TextEditingController _nameCtrl = TextEditingController();
  List<MedicalDrug> _drugs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _service.getPrescription(widget.prescriptionId);

    if (result != null) {
      _nameCtrl.text = result.prescriptionName;
      _drugs = List<MedicalDrug>.from(result.drugs);
    }

    setState(() {
      _data = result;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên đơn thuốc không được trống")),
      );
      return;
    }

    final updated = _data!.copyWith(
      prescriptionName: _nameCtrl.text,
      drugs: _drugs,
      updatedAt: DateTime.now(),
    );

    await _service.updatePrescription(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✔ Cập nhật thành công")),
    );

    Navigator.pop(context);
  }

  void _editDrug(int index) {
    final d = _drugs[index];

    final nameCtrl = TextEditingController(text: d.name);
    final dosageCtrl = TextEditingController(text: d.dosage);
    final instrCtrl = TextEditingController(text: d.instructions);

    bool morning = d.morning;
    bool noon = d.noon;
    bool evening = d.evening;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Sửa thuốc"),
          content: StatefulBuilder(builder: (context, setStateDialog) {
            return SingleChildScrollView(
              child: Column(
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
                        onChanged: (v) =>
                            setStateDialog(() => morning = v ?? false),
                      ),
                      const Text("Sáng")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: noon,
                        onChanged: (v) =>
                            setStateDialog(() => noon = v ?? false),
                      ),
                      const Text("Trưa")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: evening,
                        onChanged: (v) =>
                            setStateDialog(() => evening = v ?? false),
                      ),
                      const Text("Tối")
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Lưu"),
              onPressed: () {
                _drugs[index] = MedicalDrug(
                  name: nameCtrl.text,
                  dosage: dosageCtrl.text,
                  instructions: instrCtrl.text,
                  duration: d.duration,
                  morning: morning,
                  noon: noon,
                  evening: evening,
                );
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _addDrug() {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController();
    final instrCtrl = TextEditingController();

    bool morning = false, noon = false, evening = false;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Thêm thuốc"),
          content: StatefulBuilder(builder: (context, setStateDialog) {
            return Column(
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
                      onChanged: (v) =>
                          setStateDialog(() => morning = v ?? false),
                    ),
                    const Text("Sáng"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: noon,
                      onChanged: (v) =>
                          setStateDialog(() => noon = v ?? false),
                    ),
                    const Text("Trưa"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: evening,
                      onChanged: (v) =>
                          setStateDialog(() => evening = v ?? false),
                    ),
                    const Text("Tối"),
                  ],
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Thêm"),
              onPressed: () {
                _drugs.add(
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
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_data == null) {
      return const Scaffold(body: Center(child: Text("Không tìm thấy đơn thuốc")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa đơn thuốc")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDrug,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Tên đơn thuốc"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _drugs.length,
                itemBuilder: (context, index) {
                  final d = _drugs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${d.name} – ${d.dosage}"),
                      subtitle: Text(d.instructions),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editDrug(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _drugs.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("Lưu thay đổi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
