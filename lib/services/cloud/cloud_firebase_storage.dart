import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  //singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) {
    return notes.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CloudNote.fromSnapshot(doc),
              )
              .where((note) => note.ownerId == ownerId),
        );
  }

  void createNote({required String ownerId}) async {
    try {
      await notes.add(
        {
          ownerUserIDFieldName: ownerId,
          textFieldName: '',
        },
      );
    } catch (_) {
      throw CouldNotCreateNoteException();
    }
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerId}) async {
    try {
      return await notes
          .where(
            ownerUserIDFieldName,
            isEqualTo: ownerId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                    documentId: doc.id,
                    ownerId: doc.data()[ownerUserIDFieldName] as String,
                    text: doc.data()[textFieldName] as String);
              },
            ),
          );
    } catch (_) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
