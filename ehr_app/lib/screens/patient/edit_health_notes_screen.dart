import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/health_notes_model.dart';
import '../../services/health_notes_service.dart';

class EditHealthNotesScreen extends StatefulWidget {
  const EditHealthNotesScreen({super.key});

  @override
  State<EditHealthNotesScreen> createState() => _EditHealthNotesScreenState();
}

class _EditHealthNotesScreenState extends State<EditHealthNotesScreen> {
  final _service = HealthNotesService();
  bool _loading = true;

  List<String> allergies = [];
  List<String> conditions = [];

  final allergyCtrl = TextEditingController();
  final conditionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await _service.getHealthNotes();
    setState(() {
      allergies = data?.allergies ?? [];
      conditions = data?.conditions ?? [];
      _loading = false;
    });
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final notes = HealthNotes(
      userId: uid,
      did: uid,
      allergies: allergies,
      conditions: conditions,
      updatedAt: DateTime.now(),
    );

    await _service.saveHealthNotes(notes);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã lưu thông tin sức khỏe"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  Widget _sectionBox({
    required String title,
    required List<String> items,
    required TextEditingController controller,
    required VoidCallback onAdd,
    required Function(String) onDelete,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 16),

          // Input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Nhập thêm...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              )
            ],
          ),

          const SizedBox(height: 16),

          // Chips list
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items
                .map(
                  (item) => Chip(
                    label: Text(item),
                    labelStyle: const TextStyle(fontSize: 14),
                    deleteIcon: const Icon(Icons.close),
                    backgroundColor: color.withOpacity(0.12),
                    onDeleted: () => onDelete(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2D9CDB);
    const bg = Color(0xFFF7F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: const Text(
          "Chỉnh sửa Health Notes",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      // ===============================
      //              BODY
      // ===============================
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Allergies section
                  _sectionBox(
                    title: "Dị ứng",
                    items: allergies,
                    controller: allergyCtrl,
                    color: primary,
                    onAdd: () {
                      if (allergyCtrl.text.trim().isEmpty) return;
                      setState(() {
                        allergies.add(allergyCtrl.text.trim());
                        allergyCtrl.clear();
                      });
                    },
                    onDelete: (value) {
                      setState(() {
                        allergies.remove(value);
                      });
                    },
                  ),

                  // Conditions section
                  _sectionBox(
                    title: "Bệnh nền",
                    items: conditions,
                    controller: conditionCtrl,
                    color: Colors.green.shade600,
                    onAdd: () {
                      if (conditionCtrl.text.trim().isEmpty) return;
                      setState(() {
                        conditions.add(conditionCtrl.text.trim());
                        conditionCtrl.clear();
                      });
                    },
                    onDelete: (value) {
                      setState(() {
                        conditions.remove(value);
                      });
                    },
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),

      // ===============================
      //           SAVE BUTTON
      // ===============================
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
            ),
            child: const Text(
              "Lưu thay đổi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
