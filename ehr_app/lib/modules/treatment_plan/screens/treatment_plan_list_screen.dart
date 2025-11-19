import 'package:flutter/material.dart';

import '../models/treatment_plan.dart';
import '../services/treatment_plan_service.dart';
import 'create_treatment_plan_screen.dart';
import 'treatment_plan_detail_screen.dart';

class TreatmentPlanListScreen extends StatelessWidget {
  final String patientId;

  const TreatmentPlanListScreen({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    final TreatmentPlanService service = TreatmentPlanService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phác đồ điều trị'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateTreatmentPlanScreen(
                patientId: patientId,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tạo phác đồ'),
      ),
      body: StreamBuilder<List<TreatmentPlan>>(
        stream: service.getPlansByPatient(patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi tải phác đồ: ${snapshot.error}'),
            );
          }

          final plans = snapshot.data ?? [];

          if (plans.isEmpty) {
            return const Center(
              child: Text('Chưa có phác đồ điều trị nào'),
            );
          }

          return ListView.separated(
            itemCount: plans.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final createdAt = plan.createdAt;
              final dateStr = createdAt != null
                  ? '${createdAt.day.toString().padLeft(2, '0')}/'
                      '${createdAt.month.toString().padLeft(2, '0')}/'
                      '${createdAt.year}'
                  : '';

              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(plan.diagnosis),
                subtitle: Text('Ngày tạo: $dateStr'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TreatmentPlanDetailScreen(planId: plan.planId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
