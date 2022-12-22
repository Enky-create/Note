import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Mock Authterization tests",
    () {
      final provider = MockAuthProvider();
      test(
        "Should not be initialized",
        () {
          expect(provider.isInitialized, false);
        },
      );
      test("Cannot logout if its not initilized", () async {
        expect(
          provider.logOut(),
          throwsA(
            const TypeMatcher<NotInitializedException>(),
          ),
        );
      });
      test(
        "Can be initialized",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
      );
      test(
        "User should be null after provider initialized",
        () {
          expect(provider.currentUser, isNull);
        },
      );

      test(
        "User cannot log out when he's not logged in",
        () {
          expect(
            provider.logOut(),
            throwsA(
              const TypeMatcher<UserIsNotLoggedInAuthException>(),
            ),
          );
        },
      );

      test(
        "Should be initialized less than 2 seconds",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(Duration(seconds: 2)),
      );

      test(
        "Register function should be delegate to login function",
        () async {
          final badLogin = provider.registerUser(
            email: "foo@bar.com",
            password: "password",
          );
          final badPassword = provider.registerUser(
            email: "login",
            password: "foobar",
          );
          expect(
            badLogin,
            throwsA(
              const TypeMatcher<UserNotFoundAuthException>(),
            ),
          );
          expect(
            badPassword,
            throwsA(
              const TypeMatcher<WrongPasswordAuthException>(),
            ),
          );
          final user = await provider.registerUser(
            email: "email",
            password: "password",
          );
          expect(
            provider.currentUser,
            user,
          );
          expect(provider.currentUser!.isEmailVerified, false);
        },
      );
      test(
        "Can send email verification when user is not null",
        () async {
          await provider.sendEmailVerification();
          expect(
            provider.currentUser!.isEmailVerified,
            true,
          );
        },
      );
      test(
        "User can log out and log in",
        () async {
          await provider.logOut();
          expect(provider.currentUser, isNull);
          await provider.logIn(email: "email", password: "password");
          expect(provider.currentUser, isNotNull);
        },
      );
    },
  );
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required email,
    required password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    await Future.delayed(const Duration(seconds: 1));
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserIsNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> registerUser({
    required email,
    required password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserIsNotLoggedInAuthException();
    _user = const AuthUser(isEmailVerified: true);
  }
}
