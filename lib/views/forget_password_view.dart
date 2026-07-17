import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgetPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            if (!context.mounted) return;
            showErrorDialog(
              context,
              "can't process your request check network conectivity or credentials",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Forget Password")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Enter Your Email to Reset Password"),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Enter Email",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please Enter Email";
                        }
                        if (!value.contains("@")) {
                          return "Please Enter a Valid Email";
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final email = _controller.text;
                        context.read<AuthBloc>().add(
                          AuthEventForgetPassword(email: email),
                        );
                      },
                      child: const Text("Send me password Reset Email"),
                    ),
                    TextButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      child: const Text("Back to Login page"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
