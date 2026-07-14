import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();

    test("Should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    test("Cannot logout if not Initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<UserFireBaseAuthException>()),
      );
    });

    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("User should be null after initialized", () {
      expect(provider.currentUser, null);
    });

    test(
      "Should be able to initialized in less than 8 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 8)),
    );

    test("Create user should delegate to login function", () async {
      expect(
        provider.createUser(
          email: "admin@gmail.com",
          password: "passworddfasd",
        ),
        throwsA(isA<UserFireBaseAuthException>()),
      );

      final badPassword = provider.createUser(
        email: "ahad01pk@gmail.com",
        password: "password123",
      );
      expect(badPassword, throwsA(TypeMatcher<UserFireBaseAuthException>()));

      final user = await provider.createUser(
        email: "ahad01pk@gmail.com",
        password: "password",
      );
      expect(user, provider.currentUser);
      expect(user.isEmailVerified, false);
    });

    test("Logged In user should be able to get Verified", () async {
      await provider.logIn(email: "email", password: "password");

      await provider.sendEmailVerifications();

      final user = provider.currentUser;

      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to log out and log in again", () async {
      await provider.logIn(email: "email", password: "password");

      await provider.logOut();

      await provider.logIn(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "admin@gmail.com") {
      throw UserFireBaseAuthException("User Not Found");
    }
    if (password == "password123") {
      throw UserFireBaseAuthException("Invalid Password");
    }
    const user = AuthUser(id:"my_id",isEmailVerified: false, email: 'admin@gmail.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw UserFireBaseAuthException("User Instance not initialized");
    }
    if (_user == null) {
      throw UserFireBaseAuthException("user not Found");
    }
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerifications() async {
    if (!isInitialized) {
      throw UserFireBaseAuthException("User Instance not initialized");
    }
    final user = _user;
    if (user == null) {
      throw UserFireBaseAuthException("user not Found");
    }
    const newUser = AuthUser(id:"mu_id",isEmailVerified: true, email: 'admin@gmail.com');
    await Future.delayed(Duration(seconds: 1));
    _user = newUser;
  }
}
