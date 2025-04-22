import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/delete_confirmation_dialog.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_card.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_dialogs.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participants = Provider.of<List<Participant>>(context);

    Widget content = const SizedBox.shrink();

    if (participants.isEmpty) {
      content = const Center(child: Text('No participants found'));
    } else {
      content = ListView.separated(
        itemCount: participants.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemBuilder: (context, index) {
          final p = participants[index];
          return ParticipantCard(
            participantName: p.name,
            bibNumber: p.bibNumber,
            onEditPressed: () {
              ParticipantDialog.show(context, participants, p);
            },
            onDeletePressed: () {
              DeleteConfirmationDialog.show(context, p);
            },
          );
        },
      );
    }

    Widget headerRow = Container(
      color: RTColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Name",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: RTColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "BIB Number",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: RTColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 40), // Space for edit icon
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
        actions: [
          IconButton(
            onPressed: () {
              ParticipantDialog.show(context, participants, null);
            },
            icon: const Icon(
              Icons.add, // or Icons.add_box, Icons.person_add, etc.
              size: 32,
              color: RTColors.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          headerRow,
          const Divider(height: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}
