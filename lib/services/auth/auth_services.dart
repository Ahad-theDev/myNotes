import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;

  AuthServices(this.provider);

  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider(),);
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password,);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerifications() => provider.sendEmailVerifications();

  @override
  Future<void> initialize() => provider.initialize();
}
