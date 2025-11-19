import 'package:flutter/material.dart';
import '../../treatment_plan/services/treatment_plan_service.dart';
import '../../treatment_plan/models/treatment_plan.dart';
import '../../treatment_plan/screens/treatment_plan_detail_screen.dart';
import '../../treatment_plan/screens/patient_treatment_plan_list_screen.dart';

class PatientTreatmentPlanListScreen extends StatelessWidget {
  final String patientId;
  const PatientTreatmentPlanListScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final service = TreatmentPlanService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Phác đồ điều trị của tôi"),
      ),
      body: StreamBuilder<List<TreatmentPlan>>(
        stream: service.getPlansByPatient(patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có phác đồ nào."));
          }

          final plans = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final p = plans[index];
              return Card(
                child: ListTile(
                  title: Text(p.diagnosis),
                  subtitle: Text("Ngày tạo: ${p.createdAt}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TreatmentPlanDetailScreen(planId: p.planId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
