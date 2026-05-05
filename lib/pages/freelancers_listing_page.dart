import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/services/api_service.dart';
import '../core/models/freelancer.dart';
import '../widgets/header.dart';

class FreelancersListingPage extends StatefulWidget {
  const FreelancersListingPage({super.key});

  @override
  State<FreelancersListingPage> createState() => _FreelancersListingPageState();
}

class _FreelancersListingPageState extends State<FreelancersListingPage> {
  late Future<List<Freelancer>> _freelancersFuture;

  @override
  void initState() {
    super.initState();
    _freelancersFuture = ApiService.getFreelancers();
  }

  void _refreshFreelancers() {
    setState(() {
      _freelancersFuture = ApiService.getFreelancers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            _buildFilterBar(),
            Expanded(
              child: FutureBuilder<List<Freelancer>>(
                future: _freelancersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          TextButton(onPressed: _refreshFreelancers, child: const Text('Retry')),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No freelancers found'));
                  }

                  final freelancers = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: freelancers.length,
                    itemBuilder: (context, index) {
                      return _buildFreelancerCard(freelancers[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.withOpacity(0.05),
      child: Row(
        children: [
          const Text('Top Rated Talent', style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_outlined),
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
        ],
      ),
    );
  }

  Widget _buildFreelancerCard(Freelancer freelancer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: freelancer.profilePicUrl != null ? NetworkImage(freelancer.profilePicUrl!) : null,
                  child: freelancer.profilePicUrl == null ? Text(freelancer.name[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freelancer.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        freelancer.title ?? 'Professional Freelancer',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(freelancer.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Text('(${freelancer.reviewsCount} reviews)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  freelancer.hourlyRate != null ? 'ETB ${freelancer.hourlyRate!.toStringAsFixed(0)}/hr' : 'Negotiable',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            if (freelancer.bio != null) ...[
              const SizedBox(height: 12),
              Text(
                freelancer.bio!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
            const SizedBox(height: 16),
            if (freelancer.skills.isNotEmpty)
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: freelancer.skills.length,
                  itemBuilder: (context, sIndex) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        freelancer.skills[sIndex],
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Hire Me'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
