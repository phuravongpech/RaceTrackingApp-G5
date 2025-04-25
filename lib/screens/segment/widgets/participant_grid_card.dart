import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantGridCard extends StatelessWidget {
  final String id;
  final String name;
  final int bibNumber;
  final Segment segment;

  const ParticipantGridCard({
    super.key,
    required this.id,
    required this.name,
    required this.bibNumber,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: RTColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                bibNumber.toString(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: RTColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
