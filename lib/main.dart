import 'package:flutter/material.dart';
import 'package:healthcare/core/di/injection.dart' as di;
import 'package:healthcare/core/init/app_initializer.dart';
import 'package:healthcare/core/routing/app_router.dart';
import 'package:healthcare/core/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  String get _initialRoute {
    try {
      final prefs = di.sl<SharedPreferences>();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      return isLoggedIn ? Routes.mainLayout : Routes.getUserInfo;
    } catch (e) {
      return Routes.getUserInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: _initialRoute,
    );
  }
}
