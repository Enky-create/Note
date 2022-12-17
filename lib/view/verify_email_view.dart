import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Column(
          children: [
            const Text(
              "we've already send a verification email, please check your mail.",
            ),
            const Text(
              "If it's not there please check spam folder or click on button below.",
            ),
            TextButton(
              onPressed: (() async {
                final user = AuthService.firebase().currentUser;
                devtools.log(user.toString());
                await AuthService.firebase().sendEmailVerification();
              }),
              child: const Text("Send a verification email!"),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Back to register screen"),
            ),
          ],
        ),
      ),
    );
  }
}
