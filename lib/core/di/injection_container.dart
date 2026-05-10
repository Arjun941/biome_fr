import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../services/location_service.dart';
import '../services/auth_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/map/data/datasources/map_remote_data_source.dart';
import '../../features/map/data/repositories/map_repository_impl.dart';
import '../../features/map/domain/repositories/map_repository.dart';
import '../../features/map/domain/usecases/get_markers_usecase.dart';
import '../../features/map/presentation/bloc/map_bloc.dart';
import '../../features/feed/data/datasources/feed_remote_data_source.dart';
import '../../features/feed/data/repositories/feed_repository_impl.dart';
import '../../features/feed/domain/repositories/feed_repository.dart';
import '../../features/feed/domain/usecases/get_posts_usecase.dart';
import '../../features/feed/domain/usecases/create_post_usecase.dart';
import '../../features/feed/domain/usecases/like_post_usecase.dart';
import '../../features/feed/presentation/bloc/feed_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => AuthStorageService());

  // Restore persisted token so API calls work immediately after app restart
  final token = await sl<AuthStorageService>().getAccessToken();
  if (token != null) sl<ApiClient>().setToken(token);

  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    authStorageService: sl(),
    apiClient: sl(),
  ));

  // ── Map ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => MapRemoteDataSource());
  sl.registerLazySingleton<MapRepository>(() => MapRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetMarkersUseCase(sl()));
  sl.registerFactory(() => MapBloc(
    getMarkersUseCase: sl(),
    locationService: sl(),
  ));

  // ── Feed ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => FeedRemoteDataSource(sl()));
  sl.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => LikePostUseCase(sl()));
  sl.registerFactory(() => FeedBloc(
    getPostsUseCase: sl(),
    createPostUseCase: sl(),
    likePostUseCase: sl(),
  ));

  // ── Core Services ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LocationService());
}
