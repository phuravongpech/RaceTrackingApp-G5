import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantTableHeader extends StatelessWidget {
  const ParticipantTableHeader({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: RTColors.backgroundAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
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
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              'Participant',
              style: RTTextStyles.label.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildIconHeader(Icons.pool_rounded, 'Swimming'),
          ),
          Expanded(
            flex: 2,
            child: _buildIconHeader(Icons.pedal_bike_rounded, 'Cycling'),
          ),
          Expanded(
            flex: 2,
            child: _buildIconHeader(Icons.directions_run_rounded, 'Running'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconHeader(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 65,
        child: Icon(icon, size: 20, color: RTColors.textSecondary),
      ),
    );
  }
}
