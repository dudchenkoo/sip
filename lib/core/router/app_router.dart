import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dialer/presentation/dialer_screen.dart';
import '../../features/calls/presentation/calls_screen.dart';
import '../../features/contacts/presentation/contacts_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../widgets/app_shell.dart';

/// App route paths
abstract class AppRoutes {
  static const String login = '/login';
  static const String dialer = '/dialer';
  static const String calls = '/calls';
  static const String contacts = '/contacts';
  static const String settings = '/settings';
}

/// Global navigation key for the shell
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// App Router Configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.dialer,
  debugLogDiagnostics: true,
  routes: [
    // Login (outside shell)
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // Main app shell with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dialer,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DialerScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.calls,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CallsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.contacts,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ContactsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);
