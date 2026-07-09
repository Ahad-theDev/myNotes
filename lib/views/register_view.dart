import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

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
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _email.text.trim(),
                    password: _password.text,
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  // print(userCredential);
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;
                  await showErrorDialog(context, e.message.toString());
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(e.code ?? "Registration Failed")),
                  // );
                } catch (e) {
                  if (!mounted) return;
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () async {
                if (!context.mounted) return;
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registered? Login here!"),
            ),
          ],
        ),
      )),
    );
  }
}
