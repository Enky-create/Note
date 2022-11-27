import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/view/login_view.dart';
import 'package:notes/view/notes_view.dart';
import 'package:notes/view/register_view.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
      routes: {
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        notesRoute: (context) => const NotesView(),
      },
    ),
  );
}
