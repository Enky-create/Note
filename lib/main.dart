import 'package:flutter/material.dart';
import 'homepage.dart';
import 'view/register_view.dart';
import 'view/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    ),
  );
}
