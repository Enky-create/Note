//login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}

//registration exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Exception
class GenericAuthException implements Exception {}

class UserIsNotLoggedInAuthException implements Exception {}
