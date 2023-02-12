import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete note?',
    content: 'Are you sure?',
    optionsBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then(
    (value) => value ?? false,
  );
}
