import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/providers/race_provider.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class RaceClockLive extends StatefulWidget {
  const RaceClockLive({super.key});

  @override
  State<RaceClockLive> createState() => _RaceClockLiveState();
}

class _RaceClockLiveState extends State<RaceClockLive> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int startTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsedMs = now - startTime;
      setState(() {
        _elapsed = Duration(milliseconds: elapsedMs);
      });
    });
  }

  String _formatTime(Duration duration) {
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(RaceStatus? status) {
      if (status == null) {
        return RTColors.textSecondary; // Default to secondary color (grey)
      }

      switch (status) {
        case RaceStatus.notStarted:
          return RTColors.textSecondary; // Grey color
        case RaceStatus.started:
          return RTColors.primary; // Green or active color
        case RaceStatus.finished:
          return RTColors.textSecondary; // Blue color for finished
      }
    }

    return StreamBuilder<Race?>(
      stream: context.read<RaceProvider>().raceStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.startTime != null) {
          final race = snapshot.data!;

          // Handle different race states
          if (race.raceStatus == RaceStatus.started && race.startTime != 0) {
            _startTimer(race.startTime);
          } else if (race.raceStatus == RaceStatus.finished) {
            _timer?.cancel();
            // Calculate final duration using endTime from race
            _elapsed = Duration(milliseconds: race.endTime - race.startTime);
          } else {
            _timer?.cancel();
            _elapsed = Duration.zero;
          }
        }

        // Display logic
        String displayTime = "00:00:00";
        final race = snapshot.data;
        if (race != null) {
          if (race.raceStatus == RaceStatus.finished) {
            // Use stored endTime - startTime for finished races
            displayTime = _formatTime(
              Duration(milliseconds: race.endTime - race.startTime),
            );
          } else if (race.startTime != 0) {
            // Use current elapsed time for running races
            displayTime = _formatTime(_elapsed);
          }
        }

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: RTColors.backgroundAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: RTColors.textSecondary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  displayTime,
                  style: RTTextStyles.heading.copyWith(
                    fontSize: 56,
                    color: RTColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: getStatusColor(race!.raceStatus)),
                  const SizedBox(width: 8),
                  Text(
                    'Status : ${race.raceStatus.label}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: getStatusColor(race.raceStatus),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
