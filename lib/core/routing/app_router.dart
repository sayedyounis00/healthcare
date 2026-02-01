import 'package:flutter/material.dart';
import 'package:healthcare/core/routing/routes.dart';
import 'package:healthcare/features/Appointments/presentation/pages/appointments_view.dart';
import 'package:healthcare/features/home/presentation/home_view.dart';
import 'package:healthcare/features/mainLayout/presentation/main_layout.dart';
import 'package:healthcare/features/medicine/presentation/pages/medicine_view.dart';
import 'package:healthcare/features/userProfile/presentaion/pages/user_profile_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsView());
      case Routes.medicine:
        return MaterialPageRoute(builder: (_) => const MedicineView());
      case Routes.userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfileView());
      default:
        return null;
    }
  }
}
