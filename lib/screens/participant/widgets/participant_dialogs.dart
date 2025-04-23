import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';

class ParticipantDialog extends StatefulWidget {
  final List<Participant> currentList;
  final Participant? participantToEdit;

  const ParticipantDialog({
    super.key,
    required this.currentList,
    this.participantToEdit,
  });

  static Future<void> show(
    BuildContext context,
    List<Participant> currentList,
    Participant? participantToEdit,
  ) {
    return showDialog(
      context: context,
      builder:
          (_) => ParticipantDialog(
            currentList: currentList,
            participantToEdit: participantToEdit,
          ),
    );
  }

  @override
  State<ParticipantDialog> createState() => _ParticipantDialogState();
}

class _ParticipantDialogState extends State<ParticipantDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bibController;

  bool get isEdit => widget.participantToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.participantToEdit?.name ?? '',
    );
    _bibController = TextEditingController(
      text: widget.participantToEdit?.bibNumber.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bibController.dispose();
    super.dispose();
  }

  bool isDuplicate(int bibNumber) {
    return widget.currentList.any((p) => p.bibNumber == bibNumber);
  }

  bool isDuplicateOnEdit(String name, int bibNumber, String id) {
    return widget.currentList.any(
      (p) => p.id != id && (p.name == name || p.bibNumber == bibNumber),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final bib = int.parse(_bibController.text.trim());
    final provider = ParticipantProvider();

    if (isEdit) {
      final id = widget.participantToEdit!.id;
      if (isDuplicateOnEdit(name, bib, id)) {
        _showError("Name or Bib Number already exists");
        return;
      }
      provider.updateParticipant(id, name, bib);
    } else {
      if (isDuplicate(bib)) {
        _showError("Bib Number already exists");
        return;
      }
      provider.addParticipant(name, bib);
    }

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final label = isEdit ? "Edit" : "Add";

    return AlertDialog(
      title: Text('$label Participant'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(),
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
                controller: _bibController,
                decoration: const InputDecoration(
                  labelText: "BIB Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final num = int.tryParse(value ?? '');
                  if (num == null || num <= 0) return "Enter a valid number";
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
        ElevatedButton(onPressed: _submit, child: Text(label)),
      ],
    );
  }
}
