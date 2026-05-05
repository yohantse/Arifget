import 'package:flutter/material.dart';
import '../widgets/job_card.dart';

class JobsListingPage extends StatefulWidget {
  const JobsListingPage({super.key});

  @override
  State<JobsListingPage> createState() => _JobsListingPageState();
}

class _JobsListingPageState extends State<JobsListingPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Jobs'),
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
                hintText: 'Search for jobs...',
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
                return JobCard(
                  title: index % 2 == 0 ? 'Modern Logo Design' : 'Expert Video Editor',
                  description: 'We are looking for a creative professional to handle our brand identity and marketing materials.',
                  budget: index % 2 == 0 ? 12000 : 25000,
                  proposals: index * 5,
                  timePosted: '${index + 1}h ago',
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
            const Text('Filter Jobs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Job Type'),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(label: const Text('Fixed Price'), onSelected: (_) {}),
                FilterChip(label: const Text('Hourly'), onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Experience Level'),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(label: const Text('Entry'), onSelected: (_) {}),
                FilterChip(label: const Text('Intermediate'), onSelected: (_) {}),
                FilterChip(label: const Text('Expert'), onSelected: (_) {}),
              ],
            ),
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
