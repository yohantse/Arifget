import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance
          _buildSectionHeader('Appearance'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, _) {
              return SwitchListTile(
                secondary: Icon(
                  mode == ThemeMode.dark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Dark Mode'),
                subtitle: Text(mode == ThemeMode.dark ? 'Dark theme enabled' : 'Light theme enabled'),
                value: mode == ThemeMode.dark,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),

          const Divider(height: 1),

          // Account
          _buildSectionHeader('Account'),
          _buildTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your name, phone, bio',
            onTap: () => _showComingSoon(context, 'Edit Profile'),
          ),
          _buildTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () => _showComingSoon(context, 'Change Password'),
          ),
          _buildTile(
            icon: Icons.email_outlined,
            title: 'Email Preferences',
            onTap: () => _showComingSoon(context, 'Email Preferences'),
          ),

          const Divider(height: 1),

          // Notifications
          _buildSectionHeader('Notifications'),
          _buildTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () => _showComingSoon(context, 'Notifications'),
          ),

          const Divider(height: 1),

          // Privacy & Security
          _buildSectionHeader('Privacy & Security'),
          _buildTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showComingSoon(context, 'Privacy Policy'),
          ),
          _buildTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () => _showComingSoon(context, 'Terms of Service'),
          ),

          const Divider(height: 1),

          // About
          _buildSectionHeader('About'),
          _buildTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0 (Build 1)',
            onTap: null,
          ),
          _buildTile(
            icon: Icons.star_outline,
            title: 'Rate the App',
            onTap: () => _showComingSoon(context, 'Rate the App'),
          ),

          const Divider(height: 1),

          // Danger Zone
          _buildSectionHeader('Danger Zone'),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('Permanently delete your account and data'),
            trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onTap: () => _showComingSoon(context, 'Delete Account'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, size: 20, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — Coming Soon!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
