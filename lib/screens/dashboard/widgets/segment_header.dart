import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class SegmentHeader extends StatelessWidget {
  const SegmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: RTColors.backgroundAccent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              'BIB',
              style: RTTextStyles.label.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Participant',
              style: RTTextStyles.label.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              _buildSegmentIcon(Icons.pool_rounded, 'Swimming'),
              _buildSegmentIcon(Icons.pedal_bike_rounded, 'Cycling'),
              _buildSegmentIcon(Icons.directions_run_rounded, 'Running'),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSegmentIcon(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 65,
        child: Icon(icon, size: 20, color: RTColors.textSecondary),
      ),
    );
  }
}
