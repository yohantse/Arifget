import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class FreelancerProfilePage extends StatelessWidget {
  final String name;
  final String title;
  final double rating;
  final double hourlyRate;
  final List<String> skills;
  final String avatarUrl;

  const FreelancerProfilePage({
    super.key,
    required this.name,
    required this.title,
    required this.rating,
    required this.hourlyRate,
    required this.skills,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelancer Profile'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  backgroundImage: avatarUrl.isNotEmpty ? AssetImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 50) : null,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 4),
                          const Text('(120 reviews)', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric('ETB $hourlyRate', 'Hourly Rate'),
                _buildMetric('98%', 'Job Success'),
                _buildMetric('15', 'Active Jobs'),
              ],
            ),
            const SizedBox(height: 32),
            const Text('About Me', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'I am a passionate professional with over 5 years of experience in delivering high-quality results. My focus is on creating value for my clients through innovative solutions and attention to detail.',
              style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text('Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: skills.map((skill) => _buildSkillChip(skill)).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent to freelancer!')),
                  );
                },
                child: const Text('Contact Freelancer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
    );
  }
}
