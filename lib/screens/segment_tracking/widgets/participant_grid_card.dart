import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/providers/segment_tracking_provider.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/snack_bar_util.dart';

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
    final race = Provider.of<Race?>(context);
    final segmentProvider = Provider.of<SegmentTrackingProvider>(
      context,
      listen: false,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap:
            race?.raceStatus == RaceStatus.started
                ? () async {
                  try {
                    await segmentProvider.recordSegmentTime(
                      id,
                      segment,
                      race!.startTime,
                    );
                    SnackBarUtil.show(
                      context,
                      message: 'Time recorded for BIB #$bibNumber',
                    );
                  } catch (e) {
                    SnackBarUtil.show(
                      context,
                      message: 'Failed to record time',
                      isError: true,
                    );
                  }
                }
                : null,
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
                  color:
                      race!.raceStatus == RaceStatus.started
                          ? RTColors.primary
                          : RTColors.textSecondary,
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
