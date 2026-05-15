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
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: AppBar(
            title: const Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
                icon: const Icon(Icons.settings_outlined, color: Color(0xFF111827)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    children: [
                      _buildAvatar(user),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Loading...',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      if (user?.email != null)
                        Text(
                          user!.email,
                          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                        ),
                      const SizedBox(height: 24),
                      _buildStatsRow(user),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Role Switcher Card
                if (user != null && user.appRoles.length > 1) ...[
                  _buildRoleSwitcherCard(user),
                  const SizedBox(height: 12),
                ],

                // Menu Sections
                _buildMenuSection(
                  context,
                  'Freelance & Work',
                  [
                    _MenuData(Icons.description_outlined, 'My Proposals', 'Track your job applications'),
                    _MenuData(Icons.assignment_outlined, 'My Contracts', 'Active and past work'),
                    _MenuData(Icons.account_balance_wallet_outlined, 'Earnings', 'Withdrawals and transactions'),
                  ],
                ),
                
                _buildMenuSection(
                  context,
                  'Learning',
                  [
                    _MenuData(Icons.play_circle_outline, 'My Learning', 'Courses you are enrolled in'),
                    _MenuData(Icons.favorite_outline, 'Wishlist', 'Saved courses for later'),
                  ],
                ),

                _buildMenuSection(
                  context,
                  'Account Settings',
                  [
                    _MenuData(Icons.person_outline, 'Personal Info', 'Update your profile details'),
                    _MenuData(Icons.security_outlined, 'Security', 'Password and authentication'),
                    _MenuData(Icons.notifications_none, 'Notifications', 'Manage alerts'),
                  ],
                ),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Sign Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(User? user) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
          ),
          padding: const EdgeInsets.all(4),
          child: user?.profilePic != null
              ? CircleAvatar(
                  radius: 54,
                  backgroundImage: NetworkImage(user!.profilePic!),
                )
              : CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user?.initials ?? 'U',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(User? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat('4.9', 'Rating'),
        _buildVerticalDivider(),
        _buildStat('12', 'Jobs'),
        _buildVerticalDivider(),
        _buildStat('ETB 5K', 'Earned'),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 24, width: 1, color: const Color(0xFFE5E7EB));
  }

  Widget _buildRoleSwitcherCard(User user) {
    return ValueListenableBuilder<UserRole>(
      valueListenable: roleNotifier,
      builder: (context, currentRole, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Switch Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: user.appRoles.map((role) {
                    final isActive = currentRole == role;
                    return GestureDetector(
                      onTap: () => roleNotifier.value = role,
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isActive ? AppColors.primary : const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getRoleIcon(role),
                              size: 18,
                              color: isActive ? Colors.white : const Color(0xFF4B5563),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              role.label,
                              style: TextStyle(
                                color: isActive ? Colors.white : const Color(0xFF4B5563),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.freelancer: return Icons.work_outline;
      case UserRole.courseBuyer: return Icons.school_outlined;
      case UserRole.courseSeller: return Icons.dashboard_outlined;
      case UserRole.client: return Icons.assignment_outlined;
    }
  }

  Widget _buildMenuSection(BuildContext context, String title, List<_MenuData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 16, 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 1),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 56),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(item.icon, size: 20, color: AppColors.primary),
                ),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF9CA3AF)),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService().logout();
              isLoggedIn.value = false;
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final String subtitle;
  _MenuData(this.icon, this.title, this.subtitle);
}
