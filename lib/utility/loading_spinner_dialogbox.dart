import 'package:flutter/material.dart';
import 'loading_indicator.dart';

class ShowDialogSpinner {
  static void showDialogSpinner({required BuildContext context}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const LoadingIndicator(
        color: Colors.white,
      ),
    );
  }
}
