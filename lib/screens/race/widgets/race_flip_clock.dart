import 'package:flutter/material.dart';
import 'package:flutter_flip_clock/flutter_flip_clock.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class RaceFlipClock extends StatelessWidget {
  const RaceFlipClock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 100,
        child: FlipClock.simple(
          height: 70.0,
          width: 40.0,
          digitColor: Colors.white,
          backgroundColor: RTColors.primary,
          digitSize: 50.0,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          startTime: DateTime.timestamp(),
          timeLeft: const Duration(minutes: 1),
        ),
      ),
    );
  }
}
