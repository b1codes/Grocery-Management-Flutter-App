import '../auth_event.dart';

class RegistrationRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  RegistrationRequested({
    required this.username,
    required this.email,
    required this.password,
  });
}
