import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content: "Reset Link is Sent! check inbox or spam folder",
    optionsBuilder: () => {
      'OK':null,
    },
  );
}
