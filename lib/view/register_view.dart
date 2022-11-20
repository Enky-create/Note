import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              late final user;
              try {
                user = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _email.text, password: _password.text);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'weak-password':
                    print("Weak password");
                    break;
                  case 'email-already-in-use':
                    print("Email already in use");
                    break;
                  case 'invalid-email':
                    print("Invalid email");
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
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: (() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login/", (route) => false);
            }),
            child: const Text("Not logged in yet? Login here!"),
          ),
        ],
      ),
    );
  }
}
