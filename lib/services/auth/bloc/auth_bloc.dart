import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(const AuthStateUninitialized(isLoad: true)) {
    //send email Verification
    on<AuthEventSentEmailVerification>((event, emit) async {
      await provider.sendEmailVerifications();
      emit(state);
    });
    //Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerifications();
        emit(const AuthStateNeedsVarification(exception: null,isLoad: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e,isLoad: false));
      }
    });
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVarification(exception: null, isLoad: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoad: false));
      }
    });
    //log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: "Please wait while we log you In",
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVarification(exception: null, isLoad: false));
        } else {
          emit(AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user,isLoad: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        AuthStateLoggedOut(exception: e, isLoading: false);
      }
    });
    on<AuthEventShouldRegister>((event, emit) {
    emit(const AuthStateRegistering(exception: null, isLoad: false));
  });
  }
}
