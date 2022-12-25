import 'package:notes/constants/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:notes/services/crud/crud_database_user.dart';
import 'package:notes/services/crud/crud_database_note.dart';
import 'package:notes/services/crud/crud_exceptions.dart';

class NotesService {
  Database? _db;

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabase();
    // check if user exists in database;
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();
    const text = '';

    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSynchedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      text: text,
      userId: owner.id,
      isSynchedWithCloud: true,
    );
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabase();
    // check if note is exists
    final deleteCount = await db.delete(
      noteTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteNote();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabase();
    return await db.delete(noteTable);
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabase();
    final results = await db.query(
      noteTable,
      where: 'id=?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) throw CouldNotFindNote();

    return DatabaseNote.fromRow(results.first);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabase();
    final results = await db.query(noteTable);
    return results.map((notesRaw) => DatabaseNote.fromRow(notesRaw));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabase();
    await getNote(id: note.id);
    db.update(
      noteTable,
      {
        textColumn: text,
        isSynchedWithCloudColumn: 0,
      },
      where: 'id=?',
      whereArgs: [note.id],
    );
    return await getNote(id: note.id);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabase();
    final results = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    if (results.isEmpty) throw CouldNotFindUser();
    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabase();
    final results = await db.query(
      userTable,
      where: "email=?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) throw UserAlreadyExists();
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(
      email: email,
      id: userId,
    );
  }

  Database _getDatabase() {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpened();
    return db;
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabase();
    final deletedCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenedException();
    }
    try {
      final docsDirectoryPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsDirectoryPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    if (_db == null) throw DatabaseIsNotOpened();
    await _db!.close();
    _db = null;
  }
}