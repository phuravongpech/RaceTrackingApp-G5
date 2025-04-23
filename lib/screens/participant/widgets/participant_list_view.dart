import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_card.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_dialogs.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/delete_confirmation_dialog.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_list_header.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantListView extends StatefulWidget {
  final List<Participant> participants;
  final bool showToggle;
  final String? toggleTitle;

  const ParticipantListView({
    super.key,
    required this.participants,
    this.showToggle = false,
    this.toggleTitle,
  });

  @override
  State<ParticipantListView> createState() => _ParticipantListViewState();
}

class _ParticipantListViewState extends State<ParticipantListView> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.participants.isEmpty) {
      return const Center(child: Text('No participants found'));
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: ParticipantListHeader()),
            if (widget.showToggle)
              IconButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: RTColors.primary,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            SizedBox(width: 20),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: const Divider(height: 1, thickness: 0.2),
        ),

        if (_isExpanded || !widget.showToggle)
          Expanded(
            child: ListView.separated(
              itemCount: widget.participants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemBuilder: (context, index) {
                final p = widget.participants[index];
                return ParticipantCard(
                  participantName: p.name,
                  bibNumber: p.bibNumber,
                  onEditPressed:
                      () => ParticipantDialog.show(
                        context,
                        widget.participants,
                        p,
                      ),
                  onDeletePressed:
                      () => DeleteConfirmationDialog.show(context, p),
                );
              },
            ),
          ),
      ],
    );
  }
}
