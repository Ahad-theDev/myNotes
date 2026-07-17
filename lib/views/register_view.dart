// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

import '../services/auth/auth_exceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(context, "User-not logged In");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to Register");
          } else if (state.exception is UserFireBaseAuthException) {
            final firebaseEx = state.exception as UserFireBaseAuthException;
            await showErrorDialog(
              context,
              firebaseEx.message ?? "Registration Failed",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Register"), backgroundColor: Colors.blue),
        body: (Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Enter email"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your Email";
                  }
                  if (!value.contains("@")) {
                    return "Pleas enter Valid Email";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(hintText: "Enter password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Password";
                  }
                  if (value.length < 8) {
                    return "Password must be at least 8 characters long";
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  context.read<AuthBloc>().add(
                    AuthEventRegister(_email.text.trim(), _password.text),
                  );
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () async {
                  if (!context.mounted) return;
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Already registered? Login here!"),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
