import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../../../../core/network/api_client.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthStorageService authStorageService;
  final ApiClient apiClient;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.authStorageService,
    required this.apiClient,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);
      await authStorageService.saveAuthData(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        userId: user.id,
        username: user.username,
        email: user.email,
      );
      apiClient.setToken(user.accessToken);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(event.username, event.email, event.password);
      await authStorageService.saveAuthData(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        userId: user.id,
        username: user.username,
        email: user.email,
      );
      apiClient.setToken(user.accessToken);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await authStorageService.clearAuthData();
    apiClient.setToken(null);
    emit(AuthInitial());
  }
}
