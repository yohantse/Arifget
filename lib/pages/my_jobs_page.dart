import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu, color: Color(0xFF111827)),
          ),
          title: const Text('My Jobs', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Color(0xFF6B7280),
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Open'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOpenJobs(),
            _buildEmptyTab(
              icon: Icons.pending_outlined,
              title: 'No active jobs',
              subtitle: 'Jobs you are currently working on will appear here.',
            ),
            _buildEmptyTab(
              icon: Icons.check_circle_outline,
              title: 'No completed jobs',
              subtitle: 'Past completed contracts will be listed here.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Post a Job', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildOpenJobs() {
    final dummyJobs = [
      {
        'title': 'Flutter Developer for E-commerce App',
        'proposals': 12,
        'posted': '2 hours ago',
        'status': 'Public',
        'budget': 'ETB 15,000'
      },
      {
        'title': 'UI/UX Designer for Fintech Landing Page',
        'proposals': 5,
        'posted': 'Yesterday',
        'status': 'Invite Only',
        'budget': 'ETB 8,500'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyJobs.length,
      itemBuilder: (context, index) {
        final job = dummyJobs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      job['status'] as String,
                      style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(job['posted'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job['title'] as String,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${job['proposals']} proposals', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.payments_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(job['budget'] as String, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('View Proposals'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Edit Job'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyTab({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(icon, size: 64, color: AppColors.primary.withOpacity(0.5)),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 16, height: 1.5),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}
