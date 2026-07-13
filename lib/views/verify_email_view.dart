// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_services.dart';

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
    return Scaffold(
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
            onPressed: () async {
              try{
                AuthServices.firebase().sendEmailVerifications();
              } on UserNotLoggedInAuthException
              {
                await showErrorDialog(context, "User-not logged In",);
              } catch (e)
              {
                await showErrorDialog(context, e.toString(),);
              }
            },
            child: const Text("Send email Verification"),
          ),
          TextButton(onPressed: () async {
            try{
              await AuthServices.firebase().logOut();
            } on UserNotLoggedInAuthException
            {
              if(!context.mounted) return;
              await showErrorDialog(context, "User-not logged In",);
            }catch (e)
            {
              if(!context.mounted) return;
              await showErrorDialog(context, e.toString(),);
            }
            if(!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (r)=> false);
          }, child: const Text("Restart")),
        ],
      ),
    );
  }
}
