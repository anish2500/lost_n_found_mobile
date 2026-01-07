import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/app/theme/app_theme.dart';
import 'package:lost_n_found/features/auth/presentation/pages/login_page.dart';
import 'package:lost_n_found/features/auth/presentation/pages/signup_page.dart';
import 'package:lost_n_found/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lost_n_found/features/splash/presentation/pages/splash_page.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSessionService = ref.read(userSessionServiceProvider);
    
    return MaterialApp(
      title: 'Lost & Found',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
      onGenerateRoute: (settings) {
        // Check if user is logged in
        if (userSessionService.isLoggedIn()) {
          return MaterialPageRoute(
            builder: (_) => const DashboardPage(),
            settings: settings,
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const SignupPage(),
            settings: settings,
          );
        }
      },
    );
  }
}
