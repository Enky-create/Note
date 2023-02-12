import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/auth_exceptions.dart';

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await AuthService.firebase().registerUser(
                  email: _email.text,
                  password: _password.text,
                );
                await AuthService.firebase().sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on UserIsNotLoggedInAuthException {
                await showErrorDialog(context, "User is  not logged in");
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Weak password");
              } on InvalidEmailAuthException {
                await showErrorDialog(context, "Invalid email");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email already in use");
              } on GenericAuthException catch (e) {
                await showErrorDialog(context, "Generic eception $e");
              } catch (e) {
                await showErrorDialog(context, "Error: $e");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: (() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            }),
            child: const Text("Already register? Login here!"),
          ),
        ],
      ),
    );
  }
}
