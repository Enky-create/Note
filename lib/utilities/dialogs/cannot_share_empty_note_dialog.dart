import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context) async {
  return await showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note.',
    optionsBuilder: () => {'Ok': null},
  );
}
