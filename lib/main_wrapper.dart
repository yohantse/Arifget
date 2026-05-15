import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/courses_listing_page.dart';
import 'pages/jobs_listing_page.dart';
import 'pages/profile_page.dart';
import 'pages/my_courses_page.dart';
import 'pages/my_jobs_page.dart';
import 'pages/messages_page.dart';
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

  Widget _buildFreelancerNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    bool isActive,
    int index,
    bool isDark,
  ) {
    final color = isActive
        ? AppColors.primary
        : (isDark ? Colors.grey[400] : Colors.grey[600]);
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon,
              color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFreelancerBottomNav(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFreelancerNavItem(
              Icons.search,
              Icons.search,
              'Find Work',
              _selectedIndex == 0,
              0,
              isDark,
            ),
            _buildFreelancerNavItem(
              Icons.description_outlined,
              Icons.description,
              'Proposals',
              _selectedIndex == 1,
              1,
              isDark,
            ),
            _buildFreelancerNavItem(
              Icons.assignment_outlined,
              Icons.assignment,
              'Contracts',
              _selectedIndex == 2,
              2,
              isDark,
            ),
            _buildFreelancerNavItem(
              Icons.message_outlined,
              Icons.message,
              'Messages',
              _selectedIndex == 3,
              3,
              isDark,
            ),
            _buildFreelancerNavItem(
              Icons.notifications_none,
              Icons.notifications,
              'Alerts',
              _selectedIndex == 4,
              4,
              isDark,
            ),
          ],
        ),
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
            _buildEmptyState('Proposals', Icons.description_outlined),
            _buildEmptyState('Contracts', Icons.assignment_outlined),
            const MessagesPage(),
            _buildEmptyState('Alerts', Icons.notifications_none),
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
          ? _getFreelancerBottomNav(isDark)
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

  Widget _buildEmptyState(String title, IconData icon) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nothing to show here yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
