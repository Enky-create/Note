import 'package:bloc/bloc.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      emit(const AuthStateLoading());
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        final logInUser = user;
        emit(AuthStateLoggedIn(logInUser));
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      {
        emit(const AuthStateLoading());
        try {
          final user = await provider.logIn(
            email: event.email,
            password: event.password,
          );
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLogInFailure(e));
        }
      }
    });
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(const AuthStateLoading());
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut());
        } on Exception catch (e) {
          emit(AuthStateLogOutFailure(e));
        }
      },
    );
  }
}
