import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Participant participant;

  const DeleteConfirmationDialog({super.key, required this.participant});

  static Future<void> show(BuildContext context, Participant p) {
    return showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(participant: p),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Participant'),
      content: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: RTColors.textPrimary),
          children: [
            const TextSpan(
              text: 'Are you sure you want to delete ',
              style: TextStyle(color: RTColors.textSecondary),
            ),
            TextSpan(
              text: participant.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            ParticipantProvider().deleteParticipant(participant.id);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: RTColors.error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
