import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

import '../services/auth/auth_exceptions.dart';
// import '../utilities/show_error_dialog.dart';

// ---- Creative palette (Wise-inspired: green accent + soft purple/pink/blue) ----
const _greenBright = Color(0xFF9FE870); // Wise signature lime green
const _greenDeep = Color(0xFF0B3D2E); // near-black green for button text
const _greenFocus = Color(0xFF6FD08C); // focus border / soft green
const _purpleSoft = Color(0xFFEDE4FF); // light purple
const _pinkSoft = Color(0xFFFBE6F4); // little pinkish
const _blueSoft = Color(0xFFE2F4FF); // mix of blue
const _ink = Color(0xFF1A1A2E); // headings
const _muted = Color(0xFF8A8FA3); // sub-text
const _fieldFill = Color(0xFFF6F7FB);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await AuthServices.firebase().logIn(
        email: _email.text.trim(),
        password: _password.text,
      );
      final user = AuthServices.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(notesRoute, (r) => false);
      } else {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(verifyEmailRoute, (r) => false);
      }
    } on UserFireBaseAuthException catch (e) {
      await showErrorDialog(context, e.message ?? "Authentication failed");
    } on UserNotLoggedInAuthException {
      await showErrorDialog(context, "User-not logged In");
    } on GenericAuthException {
      await showErrorDialog(context, "Authentication Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [_purpleSoft, _pinkSoft, _blueSoft],
          ),
        ),
        child: Stack(
          children: [
            // soft decorative blobs for depth
            Positioned(
              top: -70,
              left: -50,
              child: _blob(const Color(0xFFB794F6), 220),
            ),
            Positioned(
              bottom: -90,
              right: -60,
              child: _blob(const Color(0xFF7FD8FF), 260),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 400,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // brand mark
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [_greenBright, _greenFocus],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _greenBright.withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.menu_book_rounded,
                                  color: _greenDeep,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 22),
                              const Text(
                                "Welcome back",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: _ink,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Sign in to continue to MyNotes",
                                style: TextStyle(fontSize: 15, color: _muted),
                              ),
                              const SizedBox(height: 28),
                              // email
                              TextFormField(
                                controller: _email,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _inputDecoration(
                                  hint: "Email",
                                  icon: Icons.email_outlined,
                                ),
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
                              const SizedBox(height: 16),
                              // password
                              TextFormField(
                                controller: _password,
                                obscureText: _obscurePassword,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: _inputDecoration(
                                  hint: "Password",
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                ),
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
                              const SizedBox(height: 28),
                              // login button (Wise green gradient pill)
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [_greenBright, _greenFocus],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _greenBright.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      "Log in",
                                      style: TextStyle(
                                        color: _greenDeep,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // register link
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      registerRoute,
                                      (route) => false,
                                    );
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "Not registered yet? ",
                                      style: TextStyle(
                                        color: _muted,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Register Now",
                                          style: TextStyle(
                                            color: Color(0xFF2E9E6B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: _fieldFill,
      hintText: hint,
      hintStyle: const TextStyle(color: _muted),
      prefixIcon: Icon(icon, color: _muted),
      suffixIcon:
          isPassword
              ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _muted,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
              : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _greenFocus, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _blob(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.18),
      shape: BoxShape.circle,
    ),
  );
}
