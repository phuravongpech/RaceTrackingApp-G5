import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/race.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/providers/segment_tracking_provider.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/snack_bar_util.dart';

enum ParticipantCardState { ready, undoable, notReady, completed }

extension ParticipantCardStateStyle on ParticipantCardState {
  Color get borderColor {
    switch (this) {
      case ParticipantCardState.ready:
        return RTColors.primary;
      case ParticipantCardState.undoable:
        return RTColors.error;
      default:
        return RTColors.textSecondary;
    }
  }

  // Text color is the same as the border color
  Color get textColor => borderColor;

  // Checks if the card is enabled
  bool get isEnabled =>
      this == ParticipantCardState.ready ||
      this == ParticipantCardState.undoable;

  // Checks if the card is in an undoable state
  bool get isUndoable => this == ParticipantCardState.undoable;
}

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
    final race = context.watch<Race?>();
    final segments = context.watch<List<SegmentTime>>();
    final segmentProvider = Provider.of<SegmentTrackingProvider>(
      context,
      listen: false,
    );

    // Resolve the current state of the card
    final cardState = _resolveCardState(race, segments);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cardState.borderColor, width: 2),
      ),
      child: InkWell(
        // Handle tap based on the card state
        onTap: () => _handleTap(context, cardState, race, segmentProvider),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Center(
            child: Text(
              bibNumber.toString(),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: cardState.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Determines the card state based on race and segment data
  ParticipantCardState _resolveCardState(
    Race? race,
    List<SegmentTime> segments,
  ) {
    if (race == null || race.raceStatus != RaceStatus.started) {
      return ParticipantCardState.notReady;
    }

    final participantSegments =
        segments.where((s) => s.participantId == id).toList()..sort(
          (a, b) => b.elapsedTimeInSeconds.compareTo(a.elapsedTimeInSeconds),
        );

    final hasCurrent = participantSegments.any((s) => s.segment == segment);
    final latest =
        participantSegments.isNotEmpty
            ? participantSegments.first.segment
            : null;

    final isPrevCompleted = _isPreviousCompleted(segments);

    if (hasCurrent && latest == segment) return ParticipantCardState.undoable;
    if (!hasCurrent && isPrevCompleted && _isNextSegment(latest, segment)) {
      return ParticipantCardState.ready;
    }
    if (hasCurrent) return ParticipantCardState.completed;

    return ParticipantCardState.notReady;
  }

  // Checks if the current segment is the next one after the latest completed segment
  bool _isNextSegment(Segment? latest, Segment current) {
    if (latest == null) return current == Segment.swimming;
    return current.index == latest.index + 1;
  }

  // Checks if the previous segment is completed
  bool _isPreviousCompleted(List<SegmentTime> segments) {
    if (segment == Segment.swimming) return true;
    final prev =
        segment == Segment.cycling ? Segment.swimming : Segment.cycling;
    return segments.any((s) => s.participantId == id && s.segment == prev);
  }

  // Handles tap events on the card
  Future<void> _handleTap(
    BuildContext context,
    ParticipantCardState cardState,
    Race? race,
    SegmentTrackingProvider provider,
  ) async {
    if (cardState.isUndoable) {
      // Show confirmation dialog for undo action
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Undo Confirmation'),
              content: Text(
                'Are you sure you want to undo the latest segment for BIB #$bibNumber?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text(
                    'Undo',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      );

      if (confirmed != true) return;
    }

    final successMessage =
        cardState.isUndoable
            ? 'Undo successful for BIB #$bibNumber'
            : '${segment.name} time recorded for BIB #$bibNumber';

    final errorMessage =
        cardState.isUndoable ? 'Undo failed' : 'Failed to record time';

    try {
      if (cardState.isUndoable) {
        await provider.undoLastSegment(id);
      } else {
        await provider.recordSegmentTime(id, segment, race!.startTime);
      }

      if (context.mounted) {
        SnackBarUtil.show(context, message: successMessage);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtil.show(context, message: errorMessage, isError: true);
      }
    }
  }
}
