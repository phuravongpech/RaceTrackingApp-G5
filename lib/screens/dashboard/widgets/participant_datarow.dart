import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/dashboard_row.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';
import 'package:race_tracking_app_g5/utils/date_time_util.dart';

class ParticipantDatarow extends StatelessWidget {
  const ParticipantDatarow({
    super.key,
    required this.row,
    required this.isEven,
  });

  final DashboardRow row;
  final bool isEven;
  @override
  Widget build(BuildContext context) {
    debugPrint('ParticipantTable build with ${row.participant.name} rows');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isEven ? RTColors.white : RTColors.backgroundAccent,
        border: Border.all(color: RTColors.backgroundAccent.withOpacity(0.8)),
      ),
      child: Row(
        children: [
          //BIB
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Expanded(
                      flex: 4,
                      child: Text(
                        _getStatusText(row),
                        style: RTTextStyles.label.copyWith(
                          color: RTColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildTimeSegment(
              row.swimmingSegment?.elapsedTimeInSeconds,
              RTColors.primary,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildTimeSegment(
              row.cyclingSegment?.elapsedTimeInSeconds,
              RTColors.secondary,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildTimeSegment(
              row.runningSegment?.elapsedTimeInSeconds,
              RTColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTimeSegment(int? time, Color color) {
  final hasTime = time != null;
  final display = hasTime ? DateTimeUtil.formatMillisToHourMinSec(time) : '-';

  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasTime ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        display,
        style: RTTextStyles.body.copyWith(
          fontSize: 12,
          fontWeight: hasTime ? FontWeight.w600 : FontWeight.normal,
          color: hasTime ? color : RTColors.textSecondary,
        ),
      ),
    ),
  );
}

Color _getStatusColor(DashboardRow row) {
  if (row.runningSegment != null) return RTColors.tertiary;
  if (row.cyclingSegment != null) return RTColors.secondary;
  if (row.swimmingSegment != null) return RTColors.primary;
  return RTColors.warning;
}

String _getStatusText(DashboardRow row) {
  if (row.runningSegment != null) return 'Running';
  if (row.cyclingSegment != null) return 'Cycling';
  if (row.swimmingSegment != null) return 'Swimming';
  return 'In Progress';
}
