import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleDialogWidget {
  Future<void> showSimpleDialog({
    required BuildContext context,
    required String heading,
    required String actionText,
    Color? actiontextColor,
    required void Function() onPressed,
  }) async {
    await HapticFeedback.vibrate();
    await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        title: Text(heading, textAlign: TextAlign.center),
        children: [
          const Divider(),
          SimpleDialogOption(
            onPressed: onPressed,
            child: Text(
              actionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: actiontextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              return;
            },
            child: const Text(
              "Cancel",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
