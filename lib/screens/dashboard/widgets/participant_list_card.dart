import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/date_time_util.dart';

class ParticipantListCard extends StatelessWidget {
  final dynamic row;
  final int index;

  const ParticipantListCard({
    super.key,
    required this.row,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEven = index.isEven;

    return Card(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      elevation: 0,
      color: isEven ? RTColors.white : RTColors.backgroundAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: RTColors.backgroundAccent.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            // BIB Number with colored circle
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: RTColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${row.participant.bibNumber}',
                style: RTTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: RTColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Participant name
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.participant.name,
                    style: RTTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(row),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(row),
                        style: RTTextStyles.label.copyWith(
                          color: RTColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Segment times
            _buildTimeSegment(
              row.swimmingSegment?.elapsedTimeInSeconds,
              RTColors.primary,
            ),
            _buildTimeSegment(
              row.cyclingSegment?.elapsedTimeInSeconds,
              RTColors.secondary,
            ),
            _buildTimeSegment(
              row.runningSegment?.elapsedTimeInSeconds,
              RTColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSegment(int? time, Color color) {
    final bool hasTime = time != null;
    final String displayText =
        hasTime ? '${DateTimeUtil.formatMillisToHourMinSec(time)}' : '—';

    return Container(
      width: 65,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasTime ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayText,
        style: RTTextStyles.body.copyWith(
          fontSize: 13,
          fontWeight: hasTime ? FontWeight.w600 : FontWeight.normal,
          color: hasTime ? color : RTColors.textSecondary,
        ),
      ),
    );
  }

  Color _getStatusColor(dynamic row) {
    // Logic to determine participant status
    if (row.runningSegment?.elapsedTimeInSeconds != null) {
      return RTColors.tertiary; // Running segment
    } else if (row.cyclingSegment?.elapsedTimeInSeconds != null) {
      return RTColors.secondary; // Cycling segment
    } else if (row.swimmingSegment?.elapsedTimeInSeconds != null) {
      return RTColors.primary; // Swimming segment
    }
    return RTColors.warning; // Not started
  }

  String _getStatusText(dynamic row) {
    // Logic to determine participant status text
    if (row.runningSegment?.elapsedTimeInSeconds != null) {
      return 'Running';
    } else if (row.cyclingSegment?.elapsedTimeInSeconds != null) {
      return 'Cycling';
    } else if (row.swimmingSegment?.elapsedTimeInSeconds != null) {
      return 'Swimming';
    }
    return 'In Progress';
  }
}
