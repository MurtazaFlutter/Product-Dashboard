import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_event.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static final Map<String, String> _mockUsers = {
    'admin@test.com': 'admin123',
    'user@test.com': 'user123',
    'demo@test.com': 'demo123',
  };

  String? _currentUserEmail;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(seconds: 1));

    final storedPassword = _mockUsers[event.email];

    if (storedPassword != null && storedPassword == event.password) {
      _currentUserEmail = event.email;
      final userName = event.email.split('@')[0];
      emit(Authenticated(
        userEmail: event.email,
        userName: userName.substring(0, 1).toUpperCase() + userName.substring(1),
      ));
    } else {
      emit(const AuthError('Invalid email or password'));
      emit(Unauthenticated());
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    _currentUserEmail = null;
    emit(Unauthenticated());
  }

  void _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) {
    if (_currentUserEmail != null) {
      final userName = _currentUserEmail!.split('@')[0];
      emit(Authenticated(
        userEmail: _currentUserEmail!,
        userName: userName.substring(0, 1).toUpperCase() + userName.substring(1),
      ));
    } else {
      emit(Unauthenticated());
    }
  }
}
