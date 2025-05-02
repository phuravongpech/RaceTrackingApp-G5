import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class RaceStatsCard extends StatelessWidget {
  final List<dynamic> rows;
  final Race race;

  const RaceStatsCard({super.key, required this.rows, required this.race});

  @override
  Widget build(BuildContext context) {
    final totalParticipants = rows.length;
    final finishedCount =
        rows
            .where(
              (row) =>
                  row.swimmingSegment?.elapsedTimeInSeconds != null &&
                  row.cyclingSegment?.elapsedTimeInSeconds != null &&
                  row.runningSegment?.elapsedTimeInSeconds != null,
            )
            .length;

    final inProgressCount =
        race.raceStatus == RaceStatus.notStarted
            ? 0
            : totalParticipants - finishedCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [RTColors.primary, Color(0xFF4AA5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: RTColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(race),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(totalParticipants.toString(), 'Participants'),
              _buildDivider(),
              _buildStatItem(inProgressCount.toString(), 'In Progress'),
              _buildDivider(),
              _buildStatItem(finishedCount.toString(), 'Finished'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 36, width: 1, color: RTColors.white);
  }

  Widget _buildHeader(Race race) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Race in Progress',
          style: RTTextStyles.title.copyWith(
            color: RTColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: RTColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      race.raceStatus == RaceStatus.started
                          ? RTColors.success
                          : RTColors.error,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'LIVE',
                style: RTTextStyles.label.copyWith(
                  color: RTColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: RTTextStyles.heading.copyWith(
            color: RTColors.white,
            fontSize: 24,
          ),
        ),
        Text(
          label,
          style: RTTextStyles.label.copyWith(
            color: RTColors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
