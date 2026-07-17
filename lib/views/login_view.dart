import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';
import '../services/auth/auth_exceptions.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;
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
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: "Loading...",
            );
          }

          if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(context, "User-not logged In");
          } else if (state.exception is UserFireBaseAuthException) {
            final fireBaseEx = state.exception as UserFireBaseAuthException;
            await showErrorDialog(
              context,
              fireBaseEx.message ?? "Authentication failed",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication Error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Colors.blue,
        ),
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
              TextButton(
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
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: Text("Not Registered yet? Register Now!"),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
