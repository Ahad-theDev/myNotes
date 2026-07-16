import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

import '../services/auth/auth_exceptions.dart';
// import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"), backgroundColor: Colors.blue),
      body: Form(
        key: _formKey,
        child: (Column(
          children: [
            TextFormField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter email"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please Enter your email";
                }
                if (!value.contains("@")) {
                  return "Please Enter a valid email";
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
                  return "Please Enter your password";
                }
                if (value.length < 8) {
                  return "Password must be alteast of 8 characters";
                }
                return null;
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is UserNotLoggedInAuthException) {
                    await showErrorDialog(context, "User-not logged In");
                  } else if (state.exception is UserFireBaseAuthException) {
                    final fireBaseEx =
                        state.exception as UserFireBaseAuthException;
                    await showErrorDialog(
                      context,
                      fireBaseEx.message ?? "Authentication failed",
                    );
                  } else if (state.exception is GenericAuthException) {
                    await showErrorDialog(context, "Authentication Error");
                  }
                }
              },
              child: TextButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  context.read<AuthBloc>().add(
                    AuthEventLogIn(_email.text.trim(), _password.text),
                  );
                },
                child: const Text("Login"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text("Not Registered yet? Register Now!"),
            ),
          ],
        )),
      ),
    );
  }
}
