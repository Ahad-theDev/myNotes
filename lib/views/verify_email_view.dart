import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

import '../services/auth/auth_exceptions.dart';
import '../utilities/dialogs/error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVarification) {
          if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(context, "User-not logged In");
          } else if (state.exception != null) {
            final excep = state.exception;
            showErrorDialog(context, excep.toString());
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Verify Email"),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            const Text(
              "We've sent you email verification,check your inbox or spam folder",
            ),
            const Text("haven't receive yet click button below"),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  const AuthEventSentEmailVerification(),
                );
              },
              child: const Text("Send email Verification"),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}
