import 'package:chat_app/presentation/auth/domain/domain.dart';
import 'package:chat_app/presentation/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDatasource;

  AuthRepositoryImpl({AuthDataSource? authDatasource})
      : authDatasource = authDatasource ?? AuthDataSourceImpl();

  @override
  Future<User> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return authDatasource.register(email, password, fullName);
  }

  @override
  Future<User> checkAuthStatus(String token) {
    return authDatasource.checkAuthStatus(token);
  }
}
