import 'package:flutter/foundation.dart';
import 'package:notes/constants/database.dart';

@immutable
class DatabaseNote {
  final int id;
  final String text;
  final int userId;
  final bool isSynchedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.text,
    required this.userId,
    required this.isSynchedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        text = map[textColumn] as String,
        userId = map[userIdColumn] as int,
        isSynchedWithCloud =
            (map[isSynchedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      'Note ID: $id, user Id: $userId, IsSynchedWithCloud: $isSynchedWithCloud, Text: $text';
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
