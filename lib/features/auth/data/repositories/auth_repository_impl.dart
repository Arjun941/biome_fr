import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) =>
      remoteDataSource.login(email, password);

  @override
  Future<User> register(String username, String email, String password) =>
      remoteDataSource.register(username, email, password);
}
