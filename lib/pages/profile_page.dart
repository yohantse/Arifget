import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar & Name
            const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Yohan T.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'yohan@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('My Courses', '12'),
                _buildStat('Proposals', '5'),
                _buildStat('Reviews', '4.9'),
              ],
            ),
            const SizedBox(height: 32),
            
            // Menu items
            _buildMenuItem(Icons.book_outlined, 'My Learning'),
            _buildMenuItem(Icons.favorite_outline, 'Wishlist'),
            _buildMenuItem(Icons.payment_outlined, 'Payment Methods'),
            _buildMenuItem(Icons.help_outline, 'Help & Support'),
            _buildMenuItem(Icons.logout, 'Log Out', isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }
}
