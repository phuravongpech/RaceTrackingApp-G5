import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/dashboard_row.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/participant_datarow.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/participant_header.dart';

class ParticipantTable extends StatelessWidget {
  const ParticipantTable({super.key, required this.rows});
  final List<DashboardRow> rows;

  @override
  Widget build(BuildContext context) {
    debugPrint('ParticipantTable build with ${rows.length} rows');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ParticipantTableHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: rows.length,
              itemBuilder: (_, index) {
                return ParticipantDatarow(row: rows[index], isEven: index.isEven);
              },
            ),
          ),
        ],
      ),
    );
  }
}
