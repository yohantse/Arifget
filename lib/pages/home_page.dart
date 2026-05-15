import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../widgets/header.dart';
import '../widgets/course_card.dart';
import '../widgets/job_card.dart';
import '../widgets/freelancer_card.dart';
import '../core/services/api_service.dart';
import '../core/models/course.dart';
import '../core/models/job.dart';
import '../core/models/freelancer.dart';
import 'courses_listing_page.dart';
import 'jobs_listing_page.dart';
import 'freelancers_listing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Course>> _featuredCoursesFuture;
  late Future<List<Job>> _recentJobsFuture;
  late Future<List<Freelancer>> _topFreelancersFuture;

  @override
  void initState() {
    super.initState();
    _featuredCoursesFuture = ApiService.getCourses(limit: 5);
    _recentJobsFuture = ApiService.getJobs();
    _topFreelancersFuture = ApiService.getFreelancers();
  }

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
                // Implement search navigation
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _featuredCoursesFuture = ApiService.getCourses(limit: 5);
                    _recentJobsFuture = ApiService.getJobs();
                    _topFreelancersFuture = ApiService.getFreelancers();
                  });
                },
                child: ListView(
                  children: [
                    _buildHero(context),
                    _buildSectionTitle(context, 'Featured Courses', onSeeAll: () => _navigateToCourses(context)),
                    _buildCourseList(),
                    _buildSectionTitle(context, 'Recent Jobs', onSeeAll: () => _navigateToJobs(context)),
                    _buildJobList(),
                    _buildSectionTitle(context, 'Top Freelancers', onSeeAll: () => _navigateToTalent(context)),
                    _buildFreelancerList(),
                    const SizedBox(height: 40),
                  ],
                ),
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
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Master New Skills with Arifget',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Explore thousands of courses from top instructors and freelancers in Ethiopia and beyond.',
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _navigateToCourses(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          TextButton(onPressed: onSeeAll, child: const Text('View All')),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return SizedBox(
      height: 280,
      child: FutureBuilder<List<Course>>(
        future: _featuredCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading courses'));
          }
          final courses = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                title: course.title,
                instructor: course.instructorName ?? 'Instructor',
                price: course.price.toDouble(),
                rating: 4.8, // Mock rating if not in API
                imageUrl: course.previewImageUrl ?? '',
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildJobList() {
    return FutureBuilder<List<Job>>(
      future: _recentJobsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error loading jobs'));
        }
        final jobs = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: jobs.length > 3 ? 3 : jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return JobCard(
              title: job.title,
              description: job.description,
              budget: job.budgetAmount?.toDouble() ?? 0.0,
              proposals: 10,
              timePosted: 'Recent',
            );
          },
        );
      },
    );
  }

  Widget _buildFreelancerList() {
    return FutureBuilder<List<Freelancer>>(
      future: _topFreelancersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error loading freelancers'));
        }
        final freelancers = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: freelancers.length > 3 ? 3 : freelancers.length,
          itemBuilder: (context, index) {
            final f = freelancers[index];
            return FreelancerCard(
              name: f.name,
              title: f.title ?? 'Professional',
              rating: f.rating,
              hourlyRate: f.hourlyRate?.toDouble() ?? 0.0,
              skills: f.skills,
              avatarUrl: f.profilePicUrl ?? '',
            );
          },
        );
      },
    );
  }
}
