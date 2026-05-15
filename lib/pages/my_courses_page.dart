import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FB),
        appBar: AppBar(
          title: const Text('Instructor Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? Colors.white60 : const Color(0xFF6B7280),
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: 'My Courses'),
              Tab(text: 'Earnings'),
              Tab(text: 'Students'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyCoursesTab(isDark),
            _buildEarningsTab(isDark),
            _buildStudentsTab(isDark),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Course — Coming Soon!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildMyCoursesTab(bool isDark) {
    final courses = [
      {
        'title': 'Advanced Flutter Clean Architecture',
        'students': 450,
        'rating': 4.9,
        'status': 'Published',
        'price': 'ETB 1,200',
        'image': 'https://img-c.udemycdn.com/course/480x270/2361248_e99f_11.jpg',
      },
      {
        'title': 'Mastering Figma for Mobile Design',
        'students': 120,
        'rating': 4.7,
        'status': 'Under Review',
        'price': 'ETB 850',
        'image': 'https://img-c.udemycdn.com/course/480x270/2451312_77e3_12.jpg',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.network(
                  course['image'] as String,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.video_library_outlined, color: AppColors.primary),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: course['status'] == 'Published' 
                                  ? Colors.green.withOpacity(0.1) 
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course['status'] as String,
                              style: TextStyle(
                                color: course['status'] == 'Published' ? Colors.green : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(course['price'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        course['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text('${course['rating']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          const Icon(Icons.people_outline, color: Colors.grey, size: 14),
                          const SizedBox(width: 4),
                          Text('${course['students']} students', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEarningsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatsCard('Current Balance', 'ETB 24,500', Icons.account_balance_wallet_outlined, AppColors.primary, isDark),
        const SizedBox(height: 12),
        _buildStatsCard('Total Sales', '1,240', Icons.shopping_cart_outlined, Colors.blue, isDark),
        const SizedBox(height: 12),
        _buildStatsCard('Active Students', '570', Icons.people_outline, Colors.orange, isDark),
        const SizedBox(height: 24),
        const Text('Recent Sales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        ...List.generate(5, (index) => _buildRecentSaleItem(index, isDark)),
      ],
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSaleItem(int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kebede Ayele', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Bought Flutter Architecture', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('+ETB 1,200', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
              Text('2h ago', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('Student Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Track student progress and answer questions.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
