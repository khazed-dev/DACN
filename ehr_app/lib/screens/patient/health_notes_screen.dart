import 'package:flutter/material.dart';
import '../../services/health_notes_service.dart';
import '../../models/health_notes_model.dart';
import 'edit_health_notes_screen.dart';

class HealthNotesScreen extends StatefulWidget {
  final String patientId;

  const HealthNotesScreen({super.key, required this.patientId});

  @override
  State<HealthNotesScreen> createState() => _HealthNotesScreenState();
}

class _HealthNotesScreenState extends State<HealthNotesScreen> {
  bool _loading = true;
  HealthNotes? _notes;

  final _service = HealthNotesService();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await _service.getHealthNotes();
    setState(() {
      _notes = data;
      _loading = false;
    });
  }

  Widget _buildSection(String title, List<String> items) {
    final themeColor = Color(0xFF2D9CDB); // xanh y tế

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 14),

          // LIST
          if (items.isEmpty)
            const Text("Không có dữ liệu", style: TextStyle(color: Colors.grey)),
          for (var item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: themeColor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF7F8FC); // nền trắng-xanh rất sạch

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: const Text(
          "Health Notes",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditHealthNotesScreen(),
                ),
              ).then((_) => _loadNotes());
            },
          )
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notes == null
              ? const Center(
                  child: Text(
                    "Chưa có dữ liệu sức khỏe.\nNhấn nút chỉnh sửa để thêm.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection("Dị ứng", _notes!.allergies),
                      _buildSection("Bệnh nền", _notes!.conditions),
                      const SizedBox(height: 10),

                      Text(
                        "Cập nhật lần cuối: ${_notes!.updatedAt}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
