import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/models/user.dart';
import '../core/models/user_role.dart';
import '../core/services/auth_service.dart';
import '../main.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: AuthService.userNotifier,
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Avatar & Name
                _buildAvatar(user),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'Loading...',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (user?.email != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      user!.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ValueListenableBuilder<UserRole>(
                  valueListenable: roleNotifier,
                  builder: (context, role, child) {
                    return Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role.label,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Switch Role Section — only shows roles the user actually has
                if (user != null && user.appRoles.length > 1) ...[
                  _buildSectionHeader('Switch Role'),
                  _buildRoleSwitcher(user),
                  const SizedBox(height: 16),
                ],

                // Stats Row
                _buildStatsRow(user),
                const SizedBox(height: 32),

                // Menu Items
                _buildSectionHeader('Account'),
                _buildMenuItem(
                  context,
                  Icons.book_outlined,
                  'My Learning',
                  subtitle: 'View your enrolled courses',
                ),
                _buildMenuItem(
                  context,
                  Icons.favorite_outline,
                  'Wishlist',
                  subtitle: 'Saved courses & services',
                ),
                _buildMenuItem(
                  context,
                  Icons.payment_outlined,
                  'Payment Methods',
                  subtitle: 'Manage your payment options',
                ),
                const SizedBox(height: 8),
                _buildSectionHeader('Support'),
                _buildMenuItem(
                  context,
                  Icons.help_outline,
                  'Help & Support',
                ),
                _buildMenuItem(
                  context,
                  Icons.settings_outlined,
                  'Settings',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  context,
                  Icons.logout,
                  'Log Out',
                  isDestructive: true,
                  onTap: () => _confirmLogout(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(User? user) {
    if (user?.profilePic != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(user!.profilePic!),
      );
    }
    // Initials avatar
    return CircleAvatar(
      radius: 60,
      backgroundColor: AppColors.primary,
      child: Text(
        user?.initials ?? 'U',
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatsRow(User? user) {
    final roles = user?.appRoles ?? [];
    final stats = <Map<String, String>>[];
    if (roles.contains(UserRole.courseBuyer) || roles.contains(UserRole.courseSeller)) {
      stats.add({'label': 'Courses', 'value': '—'});
    }
    if (roles.contains(UserRole.freelancer)) {
      stats.add({'label': 'Proposals', 'value': '—'});
    }
    stats.add({'label': 'Rating', 'value': '—'});

    if (stats.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats
          .map((s) => _buildStat(s['label']!, s['value']!))
          .toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSwitcher(User user) {
    return ValueListenableBuilder<UserRole>(
      valueListenable: roleNotifier,
      builder: (context, currentRole, child) {
        return ListTile(
          leading: const Icon(Icons.swap_horiz, color: AppColors.primary),
          title: const Text('Current Role'),
          subtitle: Text(
            currentRole.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          trailing: PopupMenuButton<UserRole>(
            initialValue: currentRole,
            onSelected: (UserRole role) {
              roleNotifier.value = role;
            },
            itemBuilder: (BuildContext context) =>
                user.appRoles.map((role) {
              return PopupMenuItem<UserRole>(
                value: role,
                child: Row(
                  children: [
                    Icon(_getRoleIcon(role), color: Colors.grey, size: 20),
                    const SizedBox(width: 12),
                    Text(role.label),
                    if (currentRole == role) ...[
                      const Spacer(),
                      const Icon(Icons.check, color: AppColors.primary, size: 16),
                    ],
                  ],
                ),
              );
            }).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: AppColors.primary),
                ],
              ),
            ),
          ),
        );
      },
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

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    String? subtitle,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap ?? () {},
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService().logout();
              isLoggedIn.value = false;
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
