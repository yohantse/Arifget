import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/courses_listing_page.dart';
import 'pages/jobs_listing_page.dart';
import 'pages/profile_page.dart';
import 'pages/my_courses_page.dart';
import 'pages/my_jobs_page.dart';
import 'core/constants/colors.dart';
import 'core/models/user_role.dart';
import 'main.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    roleNotifier.addListener(_onRoleChanged);
  }

  @override
  void dispose() {
    roleNotifier.removeListener(_onRoleChanged);
    super.dispose();
  }

  void _onRoleChanged() {
    setState(() {
      _selectedIndex = 0; // Reset to Home when role switches
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getRoleScreen(UserRole role) {
    switch (role) {
      case UserRole.freelancer:
        return const JobsListingPage();
      case UserRole.courseBuyer:
        return const CoursesListingPage();
      case UserRole.courseSeller:
        return const MyCoursesPage();
      case UserRole.client:
        return const MyJobsPage();
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.freelancer:
        return Icons.work_outline;
      case UserRole.courseBuyer:
        return Icons.school_outlined;
      case UserRole.courseSeller:
        return Icons.dashboard_outlined;
      case UserRole.client:
        return Icons.assignment_outlined;
    }
  }

  IconData _getRoleActiveIcon(UserRole role) {
    switch (role) {
      case UserRole.freelancer:
        return Icons.work;
      case UserRole.courseBuyer:
        return Icons.school;
      case UserRole.courseSeller:
        return Icons.dashboard;
      case UserRole.client:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentRole = roleNotifier.value;

    final List<Widget> screens = [
      const HomePage(),
      _getRoleScreen(currentRole),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_getRoleIcon(currentRole)),
              activeIcon: Icon(_getRoleActiveIcon(currentRole)),
              label: currentRole.tabLabel,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
