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

  Widget _buildClock(String time) => Container(
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
      child: Text(time, style: RTTextStyles.heading.copyWith(fontSize: 56)),
    ),
  );

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

  Widget _buildStatusRow(RaceStatus status) {
    final color = getStatusColor(status);
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color),
          const SizedBox(width: 8),
          Text(
            'Status : ${status.label}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Race?>(
      stream: context.read<RaceProvider>().raceStream,
      builder: (context, snapshot) {
        final race = snapshot.data; // nullable

        // — if still loading or errored, show zeros + unknown status
        if (race == null) {
          return Column(
            children: [
              _buildClock('00:00:00'),
              const SizedBox(height: 20),
              _buildStatusRow(RaceStatus.notStarted),
            ],
          );
        }

        // — now race is non-null, but startTime/endTime may still be zero
        final start = race.startTime;
        final status = race.raceStatus;

        // timer logic
        if (status == RaceStatus.started && start > 0) {
          _startTimer(start);
        } else if (status == RaceStatus.finished && start > 0) {
          _timer?.cancel();
          final elapsedMs = (race.endTime) - start;
          _elapsed = Duration(milliseconds: elapsedMs);
        } else {
          _timer?.cancel();
          _elapsed = Duration.zero;
        }

        // display
        final displayTime =
            start == 0
                ? '00:00:00'
                : _formatTime(Duration(milliseconds: _elapsed.inMilliseconds));

        return Column(
          children: [
            _buildClock(displayTime),
            const SizedBox(height: 20),
            _buildStatusRow(status),
          ],
        );
      },
    );
  }
}
