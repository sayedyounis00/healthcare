import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/di/injection.dart';
import 'package:healthcare/core/routing/routes.dart';
import 'package:healthcare/features/Appointments/presentation/pages/appointments_view.dart';
import 'package:healthcare/features/getUserInfo/presentation/pages/get_usr_info.dart';
import 'package:healthcare/features/home/presentation/home_view.dart';
import 'package:healthcare/features/mainLayout/presentation/main_layout.dart';
import 'package:healthcare/features/medicine/presentation/pages/medicine_view.dart';
import 'package:healthcare/features/piConnection/presentation/pages/pi_connection_page.dart';
import 'package:healthcare/features/serverInfo/presentation/pages/server_info_page.dart';
import 'package:healthcare/features/userProfile/presentaion/pages/user_profile_view.dart';
import 'package:healthcare/features/liveStream/presentation/pages/live_stream_view.dart';
import 'package:healthcare/features/liveStream/presentation/cubit/live_stream_cubit.dart';

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
      case Routes.piConnection:
        return MaterialPageRoute(builder: (_) => const PiConnectionPage());
      case Routes.serverInfo:
        final serverUrl =
            settings.arguments as String? ?? 'http://192.168.1.100:8080';
        return MaterialPageRoute(
          builder: (_) => ServerInfoPage(serverUrl: serverUrl),
        );
      case Routes.getUserInfo:
        return MaterialPageRoute(builder: (_) => const GetUserInfo());
      case Routes.liveStream:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<LiveStreamCubit>(),
            child: const LiveStreamView(),
          ),
        );
      default:
        return null;
    }
  }
}
