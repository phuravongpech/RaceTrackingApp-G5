import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/screens/participant/widgets/participant_card.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participantProvider = Provider.of<ParticipantProvider>(context);

    Widget content = const SizedBox.shrink();

    if (participantProvider.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (participantProvider.hasData) {
      final participants = participantProvider.participantState?.data ?? [];

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
                showParticipantDialog(context, participantProvider, p);
              },
              onDeletePressed: () {
                showDeleteConfirmation(context, participantProvider, p);
              },
            );
          },
        );
      }
    } else if (participantProvider.participantState?.error != null) {
      content = Center(
        child: Text(
          'Error: ${participantProvider.participantState?.error}',
          style: const TextStyle(color: RTColors.error),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
        actions: [
          IconButton(
            onPressed: () {
              showParticipantDialog(context, participantProvider, null);
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
          Container(
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
          ),
          const Divider(height: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}

void showDeleteConfirmation(
  BuildContext context,
  ParticipantProvider participantProvider,
  Participant p,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Participant'),
        content: Text('Are you sure you want to delete ${p.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              participantProvider.deleteParticipant(p.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: RTColors.error),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

void showParticipantDialog(
  BuildContext context,
  ParticipantProvider provider,
  Participant? participantToEdit,
) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(
    text: participantToEdit?.name ?? '',
  );
  final bibNumberController = TextEditingController(
    text: participantToEdit?.bibNumber.toString() ?? '',
  );

  final isEdit = participantToEdit != null;
  final label = isEdit ? "Edit" : "Add";

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$label Participant'),
        content: SizedBox(
          width: 400, // adjust width as needed
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          (value == null || value.trim().isEmpty)
                              ? "Enter a name"
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: bibNumberController,
                  decoration: const InputDecoration(
                    labelText: "BIB Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final num = int.tryParse(value ?? '');
                    if (num == null || num <= 0) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final name = nameController.text.trim();
                final bibNumber = int.parse(bibNumberController.text.trim());

                if (isEdit) {
                  if (provider.isDuplicateOnEdit(
                    name,
                    bibNumber,
                    participantToEdit.id,
                  )) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Name or Bib Number already exists'),
                      ),
                    );
                    return;
                  }
                  provider.editParticipant(
                    name,
                    bibNumber,
                    participantToEdit.id,
                  );
                } else {
                  if (provider.isDuplicate(bibNumber)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bib Number already exists'),
                      ),
                    );
                    return;
                  }
                  provider.addParticipant(name, bibNumber);
                }

                Navigator.pop(context);
              }
            },
            child: Text(label),
          ),
        ],
      );
    },
  );
}
