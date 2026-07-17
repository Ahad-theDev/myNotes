import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText="Please wait a moment"});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoad}) : super(isLoading: isLoad);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({required this.exception,required bool isLoad}) : super(isLoading: isLoad);
}
// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user,required bool isLoad}) : super(isLoading: isLoad);
}

class AuthStateNeedsVarification extends AuthState {
  final Exception? exception;
  const AuthStateNeedsVarification({required this.exception,required bool isLoad}) : super(isLoading: isLoad);
}

class AuthStateLoggedOut extends AuthState with Equatable {
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception, required super.isLoading,super.loadingText = null});

  @override
  List<Object?> get props => [exception, isLoading];
}
