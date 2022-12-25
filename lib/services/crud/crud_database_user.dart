import 'package:flutter/foundation.dart';
import 'package:notes/constants/database.dart';

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : email = map[emailColumn] as String,
        id = map[idColumn] as int;

  @override
  String toString() => 'Person id: $id, email: $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
