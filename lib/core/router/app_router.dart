import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../presentation/pages/main_layout.dart';
import '../../features/feed/presentation/pages/create_post_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainLayout(),
    ),
    GoRoute(
      path: '/create-post',
      builder: (context, state) => const CreatePostPage(),
    ),
  ],
);
