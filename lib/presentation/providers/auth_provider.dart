import 'package:chat_app/presentation/auth/domain/domain.dart';
import 'package:chat_app/presentation/auth/infrastructure/infrastructure.dart';
import 'package:chat_app/presentation/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ! StateNotifierProvider - consume afuera
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

// ! State del provider
enum AuthStatus {
  cheking,
  authenticated,
  notAuthenticated,
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.cheking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

// ! Implementación de un notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } on ConnectionTimeOut {
      logout('timeout');
    } catch (e) {
      logout('Error no controlado');
    }
  }

  // ! Registro de usuario
  Future<void> registerUser({
    String? fullName,
    String? email,
    String? password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      await authRepository.register(
        email ?? '',
        password ?? '',
        fullName ?? '',
      );
    } on CustomError catch (e) {
      logout(e.message);
    } on ConnectionTimeOut {
      logout('timeout');
    } catch (e) {
      logout('Error no controlado');
    }
  }
  // !

  void _setLoggedUser(User user) async {
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );

    // ! necesito guardar el token físicamente.
    await keyValueStorageService.setKeyValue('token', user.token);
  }

  Future<void> logout([String? errorMessage]) async {
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );

    print('otro cualquier cosa');
    // ! limpiar token
    await keyValueStorageService.removeKey('token');
  }

  Future checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    print(token);

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
      return user;
    } catch (e) {
      logout();
      return null;
    }
  }
}
