import 'package:flutter/material.dart';
import '../widgets/freelancer_card.dart';

class FreelancersListingPage extends StatefulWidget {
  const FreelancersListingPage({super.key});

  @override
  State<FreelancersListingPage> createState() => _FreelancersListingPageState();
}

class _FreelancersListingPageState extends State<FreelancersListingPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Talent'),
        actions: [
          IconButton(
            onPressed: () => _showFilterSheet(context),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for talent...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return FreelancerCard(
                  name: index % 2 == 0 ? 'Natnael Teferi' : 'Selamawit Kebede',
                  title: index % 2 == 0 ? 'Full Stack Developer' : 'Expert UI/UX Designer',
                  rating: 4.9,
                  hourlyRate: index % 2 == 0 ? 500 : 450,
                  skills: const ['Flutter', 'React', 'Node.js', 'UI Design', 'Figma'],
                  avatarUrl: index % 2 == 0 ? 'logo/channels4_profile.jpg' : '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Talent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Categories'),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(label: const Text('Development'), onSelected: (_) {}),
                FilterChip(label: const Text('Design'), onSelected: (_) {}),
                FilterChip(label: const Text('Marketing'), onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Rating'),
            Slider(value: 4.5, min: 0, max: 5, divisions: 5, label: '4.5+', onChanged: (_) {}),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
