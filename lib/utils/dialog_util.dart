import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class DialogUtil {
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    Color confirmColor = RTColors.error,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
