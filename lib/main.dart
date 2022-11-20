import 'package:flutter/material.dart';
import 'package:notes/view/login_view.dart';
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
        "/register/": (context) => const RegisterView(),
        "/login/": (context) => const LoginView()
      },
    ),
  );
}
