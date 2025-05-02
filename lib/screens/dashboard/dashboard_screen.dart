import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/participant_table.dart';
import 'package:race_tracking_app_g5/screens/dashboard/widgets/race_stats_card.dart';
import 'package:race_tracking_app_g5/screens/race/widgets/race_clock_timer.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
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
          RaceStatsCard(rows: rows, race: race),
          Expanded(child: ParticipantTable(rows: rows)),
        ],
      ),
    );
  }
}
