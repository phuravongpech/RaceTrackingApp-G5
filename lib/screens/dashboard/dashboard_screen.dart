import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/participant_list_card.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/race_stats_card.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/segment_header.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_clock_timer.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/date_time_util.dart';
import 'package:race_tracking_app_g5/view_model/dashboard_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showClock = false;

  @override
  Widget build(BuildContext context) {
    final race = context.watch<Race>();
    final viewModel = context.watch<DashboardViewModel>();
    final rows = viewModel.dashboardRows;

    return Scaffold(
      backgroundColor: RTColors.white,
      appBar: AppBar(
        title: const Text('Race Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_showClock ? Icons.timer_off : Icons.timer),
            onPressed: () {
              setState(() {
                _showClock = !_showClock;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              // filtering  if want to filter by segment
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showClock) const RaceClockLive(),
          SizedBox(height: 12),
          RaceStatsCard(context, rows: rows, race: race),
          SegmentHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: rows.length,
              itemBuilder: (_, index) {
                final row = rows[index];
                return ParticipantListCard(row: row, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
