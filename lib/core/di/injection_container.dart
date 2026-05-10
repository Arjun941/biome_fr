import 'package:get_it/get_it.dart';
import '../services/location_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
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
import '../../features/feed/presentation/bloc/feed_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());

  // Map
  sl.registerFactory(() => MapBloc(
    getMarkersUseCase: sl(),
    locationService: sl(),
  ));
  sl.registerLazySingleton(() => GetMarkersUseCase(sl()));
  sl.registerLazySingleton<MapRepository>(() => MapRepositoryImpl(sl()));
  sl.registerLazySingleton(() => MapRemoteDataSource());

  // Feed
  sl.registerFactory(() => FeedBloc(getPostsUseCase: sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl(sl()));
  sl.registerLazySingleton(() => FeedRemoteDataSource());

  // Core Services
  sl.registerLazySingleton(() => LocationService());
}
