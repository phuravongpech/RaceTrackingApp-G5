import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/providers/participant_provider.dart';
import 'package:race_tracking_app_g5/utils/snack_bar_util.dart';

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
    final provider = Provider.of<ParticipantProvider>(context, listen: false);

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
    SnackBarUtil.show(context, message: message, isError: true);
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
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                textCapitalization:
                    TextCapitalization.words, // Capitalize each word
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ), // Only letters and spaces
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter a name";
                  }
                  if (value.trim().length < 2) {
                    return "Name must be at least 2 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bibController,
                decoration: const InputDecoration(
                  labelText: "BIB Number (3 digits max)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
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

