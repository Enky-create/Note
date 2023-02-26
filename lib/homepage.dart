import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/view/login_view.dart';
import 'package:notes/view/notes/notes_view.dart';
import 'package:notes/view/verify_email_view.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    bloc.add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: ((context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else {
        return const Scaffold(body: CircularProgressIndicator());
      }
    }));

    // return FutureBuilder(
    //   future: AuthService.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         final currentUser = AuthService.firebase().currentUser;
    //         if (currentUser != null) {
    //           if (currentUser.isEmailVerified) {
    //             return const NotesView();
    //           } else {
    //             return const VerifyEmailView();
    //           }
    //         } else {
    //           return const LoginView();
    //         }

    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // );
  }
}

// ---------------------------------------------------------------------------

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;
//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing Bloc'),
//         ),
//         body:
//             BlocConsumer<CounterBloc, CounterState>(listener: (context, state) {
//           _controller.clear();
//         }, builder: (context, state) {
//           final invalidNumber =
//               (state is InvalidNumberCounterState) ? state.invalidValue : '';
//           return Column(
//             children: [
//               Text('Current value: ${state.value}'),
//               Visibility(
//                 visible: (state is InvalidNumberCounterState),
//                 child: Text('invalid number => $invalidNumber'),
//               ),
//               TextField(
//                 controller: _controller,
//                 decoration:
//                     const InputDecoration(hintText: 'Enter an adding number'),
//                 keyboardType: TextInputType.number,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           context.read<CounterBloc>().add(
//                                 IncrementEvent(value: _controller.text),
//                               );
//                         },
//                         icon: const Icon(Icons.add),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           context.read<CounterBloc>().add(
//                                 DecrementEvent(value: _controller.text),
//                               );
//                         },
//                         icon: const Icon(Icons.remove),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class ValidNumberCounterState extends CounterState {
//   const ValidNumberCounterState({required int value}) : super(value);
// }

// class InvalidNumberCounterState extends CounterState {
//   final String invalidValue;
//   const InvalidNumberCounterState({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent({required String value}) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent({required String value}) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const ValidNumberCounterState(value: 0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(InvalidNumberCounterState(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit(ValidNumberCounterState(value: state.value + integer));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(InvalidNumberCounterState(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit(ValidNumberCounterState(value: state.value - integer));
//       }
//     });
//   }
// }
