import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class CourseDetailsPage extends StatefulWidget {
  final String title;
  final String instructor;
  final double price;
  final double rating;

  const CourseDetailsPage({
    super.key,
    required this.title,
    required this.instructor,
    required this.price,
    required this.rating,
  });

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroInfo(),
                _buildPreviewSection(),
                _buildTabs(),
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildStickyFooter(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      title: Text(widget.title, style: const TextStyle(fontSize: 16)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
      ],
    );
  }

  Widget _buildHeroInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Development',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text('${widget.rating} (1,240 reviews)', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              const Text('15,400 students', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 16, color: Colors.white)),
              const SizedBox(width: 8),
              const Text('Created by '),
              Text(widget.instructor, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text('Last updated 05/2024', style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(width: 12),
              Icon(Icons.language, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text('English, Amharic', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      width: double.infinity,
      height: 220,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/600x400'), // Replace with actual image
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: const Center(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white24,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Curriculum'),
        Tab(text: 'Instructor'),
        Tab(text: 'Reviews'),
      ],
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 400, // Fixed height for demo, better to use slivers for content
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCurriculumTab(),
          _buildInstructorTab(),
          _buildReviewsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What you\'ll learn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildCheckItem('Build professional grade mobile apps'),
          _buildCheckItem('Master Dart programming language'),
          _buildCheckItem('Implement complex UI designs'),
          _buildCheckItem('Connect apps to cloud backends'),
          const SizedBox(height: 24),
          const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            'This course is designed for beginners and intermediate developers who want to master Flutter. We cover everything from basic widgets to advanced state management and animations.',
            style: TextStyle(height: 1.5, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.play_circle_outline, color: Colors.grey),
          title: Text('Section ${index + 1}: Introduction to the course'),
          subtitle: const Text('15:20 mins'),
          trailing: const Icon(Icons.lock_outline, size: 18),
        );
      },
    );
  }

  Widget _buildInstructorTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 40, backgroundColor: AppColors.primary, child: Icon(Icons.person, size: 40, color: Colors.white)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.instructor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Senior Software Engineer', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Arif Team is a collective of developers and designers committed to sharing knowledge and building high-quality software solutions.',
            style: TextStyle(height: 1.5, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(radius: 12, child: Icon(Icons.person, size: 12)),
                    SizedBox(width: 8),
                    Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text('2 days ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (i) => Icon(Icons.star, color: i < 4 ? Colors.amber : Colors.grey, size: 14)),
                ),
                const SizedBox(height: 8),
                const Text('Great course! Very clear explanations and practical examples.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStickyFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ETB ${widget.price}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const Text('Full lifetime access', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Enroll Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
