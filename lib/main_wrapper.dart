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
        return const JobsListingPage(); // This is for safety, but we bypass it in screens list
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

  Widget _buildFreelancerNavItem(IconData icon, String label, bool isActive, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : const Color(0xFF888888),
            size: 26,
            shadows: isActive ? [const Shadow(color: Colors.white, blurRadius: 12)] : null,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF888888),
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFreelancerBottomNav() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFreelancerNavItem(Icons.work, 'Jobs', _selectedIndex == 0, 0),
              _buildFreelancerNavItem(Icons.description_outlined, 'Proposals', _selectedIndex == 1, 1),
              _buildFreelancerNavItem(Icons.assignment_outlined, 'Contracts', _selectedIndex == 2, 2),
              _buildFreelancerNavItem(Icons.message_outlined, 'Messages', _selectedIndex == 3, 3),
              _buildFreelancerNavItem(Icons.notifications_none, 'Alerts', _selectedIndex == 4, 4),
            ],
          ),
          // Android navigation area
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 24,
            color: const Color(0xFF000000),
            child: Center(
              child: Container(
                width: 130,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentRole = roleNotifier.value;

    final List<Widget> screens = currentRole == UserRole.freelancer
        ? [
            const JobsListingPage(),
            const Scaffold(backgroundColor: Color(0xFF0F0F0F), body: Center(child: Text('Proposals', style: TextStyle(color: Colors.white)))),
            const Scaffold(backgroundColor: Color(0xFF0F0F0F), body: Center(child: Text('Contracts', style: TextStyle(color: Colors.white)))),
            const Scaffold(backgroundColor: Color(0xFF0F0F0F), body: Center(child: Text('Messages', style: TextStyle(color: Colors.white)))),
            const Scaffold(backgroundColor: Color(0xFF0F0F0F), body: Center(child: Text('Alerts', style: TextStyle(color: Colors.white)))),
          ]
        : [
            const HomePage(),
            _getRoleScreen(currentRole),
            const ProfilePage(),
          ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: currentRole == UserRole.freelancer
          ? _getFreelancerBottomNav()
          : Container(
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
