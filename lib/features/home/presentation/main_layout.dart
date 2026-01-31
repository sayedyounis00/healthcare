import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/features/appointments/presentation/pages/appointments_view.dart';
import 'package:healthcare/features/home/presentation/home_view.dart';
import 'package:healthcare/features/medicine/presentation/pages/medicine_view.dart';
import 'package:healthcare/features/userProfile/presentaion/pages/user_profile_view.dart';
import 'package:line_icons/line_icons.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const AppointmentsView(),
    const MedicineView(),
    const UserProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          boxShadow: [BoxShadow(blurRadius: 20, color: AppColors.shadow)],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: AppColors.skyBlue,
              hoverColor: AppColors.skyBlue,
              gap: 8,
              activeColor: AppColors.medicalBlue,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.skyBlue,
              color: AppColors.gray600,
              tabs: const [
                GButton(icon: LineIcons.home, text: 'Home'),
                GButton(icon: LineIcons.calendar, text: 'Appts'),
                GButton(icon: LineIcons.plus, text: 'Add'),
                GButton(icon: LineIcons.user, text: 'Profile'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
