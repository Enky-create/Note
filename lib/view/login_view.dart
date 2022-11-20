import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text("Login"),
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
              late final UserCredential user;
              try {
                user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _email.text, password: _password.text);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'user-not-found':
                    print("User not found");
                    break;
                  case 'wrong-password':
                    print("wrong password");
                    break;
                  case 'too-many-requests':
                    print("too many requests");
                    break;
                  default:
                    print(e.code);
                }
              }
              print(user);
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: (() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/register/", (route) => false);
            }),
            child: const Text("Not registered yet? Register here"),
          ),
        ],
      ),
    );
  }
}
