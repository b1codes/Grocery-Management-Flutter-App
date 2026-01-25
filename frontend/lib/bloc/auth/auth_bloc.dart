import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/services/managers/auth_manager.dart';

import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthManager _authManager;

  AuthBloc({required AuthManager authManager})
    : _authManager = authManager,
      super(const AuthState.unknown()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegistrationRequested>(_onRegistrationRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    try {
      final user = await _authManager.login(event.email, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    _authManager.logout();
    emit(const AuthState.unauthenticated());
  }

  void _onRegistrationRequested(
    RegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authManager.register(
        event.username,
        event.email,
        event.password,
      );
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }
}
