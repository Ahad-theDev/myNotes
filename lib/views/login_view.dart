import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

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
      appBar: AppBar(title: const Text("Login"),
      backgroundColor: Colors.blue,),
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
              validator: (value)
              {
                if(value == null || value.trim().isEmpty)
                {
                  return "Please Enter your email";
                }
                if (!value.contains("@"))
                {
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
              validator: (value)
              {
                if (value == null || value.isEmpty)
                {
                  return "Please Enter your password";
                }
                if (value.length < 8)
                {
                  return "Password must be alteast of 8 characters";
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate())
                {
                  return;
                }
                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _email.text.trim(),
                    password: _password.text,
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (r) => false);
                  // devtools.log(userCredential.toString());
                  // print(userCredential);

                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? "Authentication failed"),
                    ),
                  );
                }
              },
              child: const Text("Login"),
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
                child: Text("Not Registered yet? Register Now!"),
            ),
          ],
        )),
      ),
    );
  }
}
