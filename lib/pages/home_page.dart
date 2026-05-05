import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/course_card.dart';
import '../widgets/job_card.dart';
import '../widgets/freelancer_card.dart';
import 'courses_listing_page.dart';
import 'jobs_listing_page.dart';
import 'freelancers_listing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToCourses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CoursesListingPage()),
    );
  }

  void _navigateToJobs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JobsListingPage()),
    );
  }

  void _navigateToTalent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FreelancersListingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              onSearchSubmit: (query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoursesListingPage(initialSearch: query)),
                );
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildHero(context),
                  _buildSectionTitle(context, 'Featured Courses', onSeeAll: () => _navigateToCourses(context)),
                  _buildCourseList(isFeatured: true),
                  _buildSectionTitle(context, 'Recent Jobs', onSeeAll: () => _navigateToJobs(context)),
                  _buildJobList(),
                  _buildSectionTitle(context, 'Top Freelancers', onSeeAll: () => _navigateToTalent(context)),
                  _buildFreelancerList(),
                  _buildSectionTitle(context, 'New Courses', onSeeAll: () => _navigateToCourses(context)),
                  _buildCourseList(isFeatured: false),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Master New Skills with Arifget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Explore thousands of courses from top instructors and freelancers in Ethiopia and beyond.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _navigateToCourses(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF059669),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Find Courses'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _navigateToJobs(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Find Jobs'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList({required bool isFeatured}) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return CourseCard(
            title: isFeatured 
              ? 'Complete Flutter Bootcamp 2024' 
              : 'Digital Marketing Essentials',
            instructor: isFeatured ? 'Arif Team' : 'Sara Mohammed',
            price: isFeatured ? 1200 : 850,
            isNew: !isFeatured,
            rating: isFeatured ? 4.8 : 4.5,
          );
        },
      ),
    );
  }

  Widget _buildJobList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return JobCard(
          title: index == 0 ? 'Logo Design for Cultural Cafe' : 'Social Media Manager Needed',
          description: 'We need a professional freelancer to handle our branding and online presence.',
          budget: index == 0 ? 5000 : 15000,
          proposals: (index + 1) * 8,
          timePosted: '${index + 2}h ago',
        );
      },
    );
  }

  Widget _buildFreelancerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return FreelancerCard(
          name: index == 0 ? 'Natnael Teferi' : 'Selamawit Kebede',
          title: index == 0 ? 'Full Stack Developer' : 'Expert UI/UX Designer',
          rating: 4.9,
          hourlyRate: index == 0 ? 500 : 450,
          skills: const ['Flutter', 'React', 'Figma'],
          avatarUrl: index == 0 ? 'logo/channels4_profile.jpg' : '',
        );
      },
    );
  }
}
