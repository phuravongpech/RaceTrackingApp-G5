// ignore_for_file: use_build_context_synchronously

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
    final race = context.watch<Race?>()!;
    final segmentsStream = context.watch<List<SegmentTime>>();

    // check if it has been recorded previous segment
    final isPrevSegmentCompleted = () {
      if (segment == Segment.swimming) return true;
      final prevSegment =
          segment == Segment.cycling ? Segment.swimming : Segment.cycling;
      return segmentsStream.any(
        (st) => st.participantId == id && st.segment == prevSegment,
      );
    }();

    //
    final isCurrentSegmentRecorded = segmentsStream.any(
      (st) => st.participantId == id && st.segment == segment,
    );

    final isEnabled =
        race.raceStatus == RaceStatus.started &&
        isPrevSegmentCompleted &&
        !isCurrentSegmentRecorded;

    //for when race start but prev segment not recorded yet
    final showError =
        race.raceStatus == RaceStatus.started && !isPrevSegmentCompleted;

    return _buildCard(
      context,
      isEnabled: isEnabled,
      showError: showError,
      isLoading: false,
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required bool isEnabled,
    required bool isLoading,
    bool showError = false,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          if (isEnabled) {
            final race = Provider.of<Race?>(context, listen: false);
            final segmentProvider = Provider.of<SegmentTrackingProvider>(
              context,
              listen: false,
            );

            try {
              await segmentProvider.recordSegmentTime(
                id,
                segment,
                race!.startTime,
              );
              SnackBarUtil.show(
                context,
                message: '${segment.name} time recorded for BIB #$bibNumber',
              );
            } catch (e) {
              SnackBarUtil.show(
                context,
                message: 'Failed to record time',
                isError: true,
              );
            }
          } else if (showError) {
            SnackBarUtil.show(
              context,
              message: 'Complete previous segment first',
              isError: true,
            );
          }
        },
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
              if (isLoading)
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                )
              else
                Text(
                  bibNumber.toString(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color:
                        isEnabled ? RTColors.primary : RTColors.textSecondary,
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
