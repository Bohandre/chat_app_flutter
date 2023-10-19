// ignore_for_file: avoid_print

import 'package:chat_app/config/global/environments.dart';
import 'package:chat_app/presentation/auth/domain/domain.dart';
import 'package:chat_app/presentation/auth/infrastructure/infrastructure.dart';
import 'package:dio/dio.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environments.apiUrl,
  ));

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final user = UserMapper.userJsonToEntity(response.data);

      // print('''
      //   uid: ${user.uid},
      //   email: ${user.email},
      //   nombre: ${user.fullName},
      //   token: ${user.token},
      // ''');

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['msg'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post('/login/new', data: {
        'email': email,
        'password': password,
        'nombre': fullName,
      });

      print(response);

      return response as User;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['msg'] ?? '');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> checkAuthStatus(String token) async {
    // print('hola checkstatus');
    try {
      final response = await dio.get(
        '/login/renew',
        options: Options(
          headers: {
            'x-token': token,
          },
        ),
      );

      // print(response.data);

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  // @override
  // Future<User> checkAuthStatus(String token) async {
  //   try {
  //     final response = await dio.get(
  //       '/auth/check-status',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );

  //     final user = UserMapper.userJsonToEntity(response.data);

  //     return user;
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 401) {
  //       throw CustomError('Token incorrecto');
  //     }
  //     if (e.type == DioExceptionType.connectionTimeout) {
  //       throw CustomError('Revisar conexión a internet');
  //     }
  //     throw Exception();
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }
}
