import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser?.emailVerified ?? false) {
                return const Center(child: Text('verified'));
              } else {
                return const Center(child: Text('not verified'));
              }
            default:
              return const Center(child: Text('loading'));
          }
        },
      ),
    );
  }
}
