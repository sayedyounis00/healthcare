import 'package:flutter/material.dart';
import 'package:healthcare/core/init/app_initializer.dart';
import 'package:healthcare/core/routing/app_router.dart';
import 'package:healthcare/core/routing/routes.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: Routes.mainLayout,
    );
  }
}
