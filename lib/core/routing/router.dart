import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardPage();
      },
    ),
  ],
);
