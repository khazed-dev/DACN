import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../models/treatment_plan_model.dart';
import '../../services/treatment_plan_service.dart';

class TreatmentPlanDetailScreen extends StatelessWidget {
  final String planId;

  const TreatmentPlanDetailScreen({
    super.key,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    final TreatmentPlanService service = TreatmentPlanService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phác đồ'),
      ),
      body: StreamBuilder<TreatmentPlan?>(
        stream: service.watchPlan(planId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi tải phác đồ: ${snapshot.error}'),
            );
          }

          final plan = snapshot.data;
          if (plan == null) {
            return const Center(
              child: Text('Không tìm thấy phác đồ'),
            );
          }

          final createdAt = plan.createdAt;
          final updatedAt = plan.updatedAt;
          final dateStr = createdAt != null
              ? '${createdAt.day.toString().padLeft(2, '0')}/'
                  '${createdAt.month.toString().padLeft(2, '0')}/'
                  '${createdAt.year}'
              : '';

          final steps = [...plan.steps];
          steps.sort((a, b) => a.day.compareTo(b.day));

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  plan.diagnosis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18),
                    const SizedBox(width: 4),
                    Text('Bác sĩ ID: ${plan.doctorId}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 4),
                    Text('Ngày tạo: $dateStr'),
                  ],
                ),
                if (updatedAt != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.update, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Cập nhật lần cuối: '
                        '${updatedAt.day.toString().padLeft(2, '0')}/'
                        '${updatedAt.month.toString().padLeft(2, '0')}/'
                        '${updatedAt.year}',
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                if (plan.notes.isNotEmpty) ...[
                  const Text(
                    'Ghi chú chung',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(plan.notes),
                  const SizedBox(height: 16),
                ],
                const Text(
                  'Timeline điều trị',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ..._buildTimeline(steps),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTimeline(List<TreatmentStep> steps) {
    if (steps.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('Chưa có bước điều trị nào'),
        ),
      ];
    }

    final List<Widget> tiles = [];
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isFirst = i == 0;
      final isLast = i == steps.length - 1;

      tiles.add(
        TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: const LineStyle(thickness: 2),
          afterLineStyle: const LineStyle(thickness: 2),
          indicatorStyle: const IndicatorStyle(
            width: 20,
            height: 20,
          ),
          endChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày ${step.day}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(step.description),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return tiles;
  }
}
