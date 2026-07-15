import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You cannot Share Empty Dialog",
    optionsBuilder: () => {'OK': null},
  );
}
