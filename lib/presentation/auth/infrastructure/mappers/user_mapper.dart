import 'package:chat_app/presentation/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        uid: json['usuario']['uid'],
        email: json['usuario']['email'],
        fullName: json['usuario']['nombre'],
        token: json['token'] ?? json['newToken'] ?? '',
      );
}
