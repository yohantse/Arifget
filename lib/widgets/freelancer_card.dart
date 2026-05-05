import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

import '../pages/freelancer_profile_page.dart';

class FreelancerCard extends StatelessWidget {
  final String name;
  final String title;
  final double rating;
  final double hourlyRate;
  final List<String> skills;
  final String avatarUrl;

  const FreelancerCard({
    super.key,
    required this.name,
    required this.title,
    required this.rating,
    required this.hourlyRate,
    required this.skills,
    this.avatarUrl = '',
  });

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreelancerProfilePage(
          name: name,
          title: title,
          rating: rating,
          hourlyRate: hourlyRate,
          skills: skills,
          avatarUrl: avatarUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToProfile(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  backgroundImage: avatarUrl.isNotEmpty ? AssetImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 30) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        title,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          const Icon(Icons.verified, color: Colors.blue, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ETB $hourlyRate',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const Text('/hr', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.take(3).map((skill) => _buildSkillBadge(skill)).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _navigateToProfile(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('View Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
    );
  }
}
