import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).primaryColor),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.cancel),
            label: const Text('No'),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
