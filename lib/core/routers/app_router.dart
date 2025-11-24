import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wp_commander/core/constants/app_constants.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';
import 'package:wp_commander/presentation/pages/error/error_404_page.dart';


final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      // Route dashboard
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: DashboardPage(),
        ),
      ),
      
      // Route liste des sites
      GoRoute(
        path: AppRoutes.sites,
        name: 'sites',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Scaffold(body: Center(child: Text("Sites List Page"))), // À créer plus tard
        ),
      ),
      
      // Route ajout site avec transitions
      GoRoute(
        path: AppRoutes.addSite,
        name: 'addSite',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Center(child: Text("Add Site Page"))), // À créer plus tard
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),
    ],
    
    // Gestion des erreurs 404
    errorPageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: const Error404Page(),
    ),
  );
});
