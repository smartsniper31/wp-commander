import 'package:go_router/go_router.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
