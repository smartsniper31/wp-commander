import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/sites/add_site_page.dart';
import '../../presentation/pages/error/error_404_page.dart';
import 'routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      // Route dashboard
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DashboardPage(),
        ),
      ),

      // Route ajout de site
      GoRoute(
        path: AppRoutes.addSite,
        name: 'addSite',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AddSitePage(),
        ),
      ),

      // Route détail site (à implémenter)
      GoRoute(
        path: AppRoutes.siteDetail,
        name: 'siteDetail',
        pageBuilder: (context, state) {
          final siteId = state.uri.queryParameters['id'];
          // TODO: Implémenter SiteDetailPage
          return MaterialPage(
            key: state.pageKey,
            child: Scaffold(
              appBar: AppBar(title: const Text('Détails du site')),
              body: Center(child: Text('Détails pour le site: $siteId')),
            ),
          );
        },
      ),
    ],

    // Gestion des erreurs 404
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const Error404Page(),
    ),
  );
});
