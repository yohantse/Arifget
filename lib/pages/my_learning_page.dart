import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class MyLearningPage extends StatelessWidget {
  const MyLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF111827)),
        ),
        title: const Text('My Learning', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _buildCourseList(isDark),
    );
  }

  Widget _buildCourseList(bool isDark) {
    final purchasedCourses = [
      {
        'title': 'Complete Flutter Development Bootcamp',
        'instructor': 'Dr. Angela Yu',
        'progress': 0.65,
        'image': 'https://img-c.udemycdn.com/course/480x270/2259120_305f_6.jpg',
      },
      {
        'title': 'Graphic Design Masterclass',
        'instructor': 'Lindsay Marsh',
        'progress': 0.12,
        'image': 'https://img-c.udemycdn.com/course/480x270/1643044_e281.jpg',
      },
    ];

    if (purchasedCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('No courses yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Start your learning journey today!', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: purchasedCourses.length,
      itemBuilder: (context, index) {
        final course = purchasedCourses[index];
        final progress = course['progress'] as double;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  course['image'] as String,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.video_library_outlined, color: AppColors.primary),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course['instructor'] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                              color: AppColors.primary,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
