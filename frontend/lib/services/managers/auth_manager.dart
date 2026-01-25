import 'package:grocery_management_frontend/models/user.dart';
import 'package:grocery_management_frontend/networking/api/auth_api.dart';
import 'package:grocery_management_frontend/networking/dto/user_dto.dart';

class AuthManager {
  final AuthApi _authApi;

  AuthManager({AuthApi? authApi}) : _authApi = authApi ?? AuthApi();

  Future<User> login(String email, String password) async {
    final response = await _authApi.login(email, password);

    final token = response.data['token'];
    _authApi.setAuthToken(token);

    final userDto = UserDto.fromMap(response.data['user']);
    return userDto.toUser();
  }

  Future<User> register(String username, String email, String password) async {
    final response = await _authApi.register(username, email, password);

    final token = response.data['token'];
    _authApi.setAuthToken(token);

    final userDto = UserDto.fromMap(response.data['user']);
    return userDto.toUser();
  }

  void logout() {
    _authApi.clearAuthToken();
  }
}

extension on UserDto {
  User toUser() {
    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      isActive: isActive,
      isStaff: isStaff,
      phoneNumber: phoneNumber,
      bio: bio,
      lastLogin: lastLogin,
    );
  }
}
