import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) async {
  return await showGenericDialog<void>(
    context: context,
    title: 'An error occured',
    content: text,
    optionsBuilder: (() {
      return {
        'Ok': null,
      };
    }),
  );
}
