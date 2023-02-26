import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/view/login_view.dart';
import 'package:notes/view/notes/create_update_note_view.dart';
import 'package:notes/view/notes/notes_view.dart';
import 'package:notes/view/register_view.dart';
import 'package:notes/view/verify_email_view.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(AuthService.firebase()),
        child: const HomePage(),
      ),
      routes: {
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}
