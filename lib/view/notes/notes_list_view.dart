import 'package:notes/services/cloud/cloud_storage_note.dart';
import 'package:flutter/material.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onUpdateNote;
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onUpdateNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: ((context, index) {
          final note = notes.elementAt(index);
          return ListTile(
            onTap: () {
              onUpdateNote(note);
            },
            title: Text(
              note.text,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(
                Icons.delete_outlined,
                color: Colors.indigo,
              ),
            ),
          );
        }));
  }
}
