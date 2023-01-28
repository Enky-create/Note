import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/enums/menu_action_enum.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            IconButton(
              onPressed: (() => Navigator.of(context).pushNamed(newNoteRoute)),
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final isLogOut = await _showLogOutDialog(context);
                    if (isLogOut) {
                      await AuthService.firebase().logOut();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                    devtools
                        .log("LOGOUT: ${AuthService.firebase().currentUser}");
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Log out"),
                  )
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: ((context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('waiting...');
                        default:
                          return const CircularProgressIndicator();
                      }
                    }));
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }

  Future<bool> _showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Log out"),
            content: const Text("Do you want to log out?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out"),
              ),
            ],
          );
        }).then((value) => value ?? false);
  }
}
