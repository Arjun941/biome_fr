import 'dart:convert';
import '../models/user_model.dart';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String username, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) return UserModel.fromJson(data);
    throw Exception(data['error'] ?? 'Login failed');
  }

  @override
  Future<UserModel> register(String username, String email, String password) async {
    final response = await apiClient.post('/auth/register', {
      'username': username,
      'email': email,
      'password': password,
    });
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 201) return UserModel.fromJson(data);
    throw Exception(data['error'] ?? 'Registration failed');
  }
}
