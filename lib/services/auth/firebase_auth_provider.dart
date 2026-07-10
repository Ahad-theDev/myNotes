import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      throw UserFireBaseAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    // TODO: implement logIn
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null)
        {
          return user;
        }
      else
        {
          throw UserNotLoggedInAuthException();
        }
    } on FirebaseAuthException catch (e) {
      throw UserFireBaseAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
    final user = currentUser;
    if (user != null)
      {
        await FirebaseAuth.instance.signOut();
      }
    else
      {
        throw UserNotLoggedInAuthException();
      }
  }

  @override
  Future<void> sendEmailVerifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await sendEmailVerifications();
    } else {
      throw UserNotLoggedInAuthException();
    }
    throw UnimplementedError();
  }
}
