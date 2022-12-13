import 'package:notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required email,
    required password,
  });
  Future<AuthUser> registerUser({
    required email,
    required password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
