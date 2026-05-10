import 'dart:async';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Dummy authentication logic
    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(id: '1', email: email);
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
