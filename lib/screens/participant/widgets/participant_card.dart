import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantCard extends StatelessWidget {
  final String participantName;
  final int bibNumber;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ParticipantCard({
    super.key,
    required this.participantName,
    required this.bibNumber,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: RTColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                participantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: RTColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                bibNumber.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: RTColors.textSecondary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: RTColors.warning),
              onPressed: onEditPressed,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: RTColors.error),
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
