import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_test/core/widgets/dashboard_layout.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:interview_test/features/auth/presentation/bloc/auth_state.dart';
import 'package:interview_test/features/auth/presentation/pages/login_page.dart';
import 'package:interview_test/features/product/presentation/pages/product_detail_page.dart';
import 'package:interview_test/features/product/presentation/pages/product_list_page.dart';
import 'package:interview_test/features/product/presentation/pages/settings_page.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(
        context.read<AuthBloc>().stream,
      ),
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isAuthenticated = authState is Authenticated;
        final isLoggingIn = state.matchedLocation == '/login';

        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }

        if (isAuthenticated && isLoggingIn) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LoginPage(),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return DashboardLayout(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProductListPage(),
              ),
            ),
            GoRoute(
              path: '/products/:id',
              pageBuilder: (context, state) {
                final productId = state.pathParameters['id']!;
                return NoTransitionPage(
                  child: ProductDetailPage(productId: productId),
                );
              },
            ),
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsPage(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
