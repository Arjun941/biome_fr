import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.accessToken,
    required super.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return UserModel(
      id: (user['_id'] ?? user['id'] ?? '').toString(),
      email: (user['email'] ?? '').toString(),
      username: (user['username'] ?? '').toString(),
      accessToken: (json['access_token'] ?? '').toString(),
      refreshToken: (json['refresh_token'] ?? '').toString(),
    );
  }
}
