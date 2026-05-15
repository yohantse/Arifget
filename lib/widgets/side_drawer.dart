import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/models/user.dart';
import '../core/models/user_role.dart';
import '../core/services/auth_service.dart';
import '../main.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ValueListenableBuilder<User?>(
      valueListenable: AuthService.userNotifier,
      builder: (context, user, child) {
        return Drawer(
          backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
          child: Column(
            children: [
              _buildHeader(context, user, isDark),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSectionHeader('Switch Experience'),
                    if (user != null)
                      ...user.appRoles.map((role) => _buildRoleItem(context, role)),
                    const Divider(),
                    _buildSectionHeader('Account'),
                    _buildMenuItem(Icons.person_outline, 'My Profile', () {
                      Navigator.pop(context);
                      // Navigate to profile if not already there
                    }),
                    _buildMenuItem(Icons.settings_outlined, 'Settings', () {
                      Navigator.pop(context);
                    }),
                    _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
                  ],
                ),
              ),
              _buildFooter(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, User? user, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            backgroundImage: user?.profilePic != null ? NetworkImage(user!.profilePic!) : null,
            child: user?.profilePic == null
                ? Text(
                    user?.initials ?? 'U',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Guest User',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user?.email ?? 'Join Arifget today',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
      ),
    );
  }

  Widget _buildRoleItem(BuildContext context, UserRole role) {
    return ValueListenableBuilder<UserRole>(
      valueListenable: roleNotifier,
      builder: (context, currentRole, child) {
        final isActive = currentRole == role;
        return ListTile(
          leading: Icon(
            _getRoleIcon(role),
            color: isActive ? AppColors.primary : Colors.grey,
          ),
          title: Text(
            role.label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primary : null,
            ),
          ),
          trailing: isActive
              ? const Icon(Icons.check_circle, color: AppColors.primary, size: 18)
              : null,
          onTap: () {
            roleNotifier.value = role;
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('v1.0.5', style: TextStyle(color: Colors.grey, fontSize: 12)),
          TextButton.icon(
            onPressed: () => AuthService().logout(),
            icon: const Icon(Icons.logout, size: 16, color: Colors.red),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
}
