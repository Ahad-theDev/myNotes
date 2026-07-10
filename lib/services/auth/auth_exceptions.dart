class UserFireBaseAuthException implements Exception {
  final String? message;

  const UserFireBaseAuthException(this.message);
}
class GenericAuthException implements Exception
{

}

class UserNotLoggedInAuthException implements Exception
{

}

