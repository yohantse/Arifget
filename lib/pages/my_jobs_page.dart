import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Jobs'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Open'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEmptyTab(
              icon: Icons.work_outline,
              title: 'No Open Jobs',
              subtitle: 'Post a job to find skilled freelancers.',
            ),
            _buildEmptyTab(
              icon: Icons.pending_outlined,
              title: 'No Active Jobs',
              subtitle: 'Jobs with hired freelancers\nwill appear here.',
            ),
            _buildEmptyTab(
              icon: Icons.check_circle_outline,
              title: 'No Completed Jobs',
              subtitle: 'Jobs you\'ve marked as done\nwill appear here.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Post a Job — Coming Soon!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Post a Job', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildEmptyTab({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
