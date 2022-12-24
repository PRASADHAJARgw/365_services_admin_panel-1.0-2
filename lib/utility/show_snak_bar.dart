import 'package:flutter/material.dart';

class ShowSnackBar {
  static String uploading = "Uploading...";
  static String cancel = "Operation cancelled.";
  static String postUploaded = "Successfully uploaded.";

  static void closeSnakbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool error = false,
    int second = 3,
    Color backGroundColor = Colors.black,
    Color errorBackGroundColor = Colors.red,
    Color textColor = Colors.white,
    SnackBarAction? action,
    TextAlign? textAlign,
  }) {
    //it is used to show the current snackbar message, by overwriting the previous snackbar message.
    closeSnakbar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: textAlign,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: second),
        backgroundColor: error ? errorBackGroundColor : backGroundColor,
        action: action,
      ),
    );
  }
}
