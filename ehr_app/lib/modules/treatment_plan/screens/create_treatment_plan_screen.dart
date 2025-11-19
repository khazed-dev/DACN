import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/treatment_plan.dart';
import '../services/treatment_plan_service.dart';

class CreateTreatmentPlanScreen extends StatefulWidget {
  final String patientId;

  const CreateTreatmentPlanScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<CreateTreatmentPlanScreen> createState() =>
      _CreateTreatmentPlanScreenState();
}

class _CreateTreatmentPlanScreenState extends State<CreateTreatmentPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final TreatmentPlanService _service = TreatmentPlanService();

  bool _isSubmitting = false;

  /// mỗi step có 3 controller để edit
  final List<_StepFormItem> _steps = [];

  @override
  void initState() {
    super.initState();
    _addStep(); // mặc định 1 step cho dễ hình dung
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    for (final s in _steps) {
      s.dayController.dispose();
      s.titleController.dispose();
      s.descriptionController.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    final index = _steps.length;
    final controller = _StepFormItem(
      dayController: TextEditingController(text: (index + 1).toString()),
      titleController: TextEditingController(),
      descriptionController: TextEditingController(),
    );
    setState(() {
      _steps.add(controller);
    });
  }

  void _removeStep(int index) {
    if (_steps.length == 1) return; // giữ ít nhất 1 step
    final item = _steps.removeAt(index);
    item.dayController.dispose();
    item.titleController.dispose();
    item.descriptionController.dispose();
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // build list steps
      final steps = _steps.map((item) {
        final day = int.tryParse(item.dayController.text) ?? 1;
        return TreatmentStep(
          day: day,
          title: item.titleController.text.trim(),
          description: item.descriptionController.text.trim(),
        );
      }).toList();

      final plan = TreatmentPlan(
        planId: '', // sẽ set trong service
        doctorId: user.uid,
        patientId: widget.patientId,
        diagnosis: _diagnosisController.text.trim(),
        notes: _notesController.text.trim(),
        steps: steps,
        createdAt: null,
        updatedAt: null,
      );

      await _service.createTreatmentPlan(plan);

      if (mounted) {
        Navigator.pop(context); // quay lại list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo phác đồ thành công')),
        );
      }
    } catch (e) {
      debugPrint('Error creating plan: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tạo phác đồ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo phác đồ điều trị'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(
                    labelText: 'Chẩn đoán',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập chẩn đoán';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú chung',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Các bước điều trị',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _addStep,
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm bước'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._buildStepFields(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      _isSubmitting ? 'Đang tạo...' : 'Tạo phác đồ',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStepFields() {
    final List<Widget> widgets = [];
    for (int i = 0; i < _steps.length; i++) {
      final item = _steps[i];
      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Bước ${i + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _removeStep(i),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: item.dayController,
                  decoration: const InputDecoration(
                    labelText: 'Ngày (day)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: item.titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề bước',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: item.descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả chi tiết',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _StepFormItem {
  final TextEditingController dayController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  _StepFormItem({
    required this.dayController,
    required this.titleController,
    required this.descriptionController,
  });
}
