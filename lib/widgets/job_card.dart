import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../pages/job_details_page.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String description;
  final double budget;
  final String level;
  final String timePosted;
  final int proposals;
  final bool isPaymentVerified;

  const JobCard({
    super.key,
    required this.title,
    required this.description,
    required this.budget,
    this.level = 'Intermediate',
    this.timePosted = '2 hours ago',
    this.proposals = 0,
    this.isPaymentVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(
              title: title,
              budget: budget,
              description: description,
            ),
          ),
        );
      },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.bookmark_border, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetaItem(Icons.payments_outlined, 'ETB ${budget.toStringAsFixed(0)}'),
                const SizedBox(width: 16),
                _buildMetaItem(Icons.bar_chart, level),
                const SizedBox(width: 16),
                if (isPaymentVerified)
                  const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.blue, size: 14),
                      SizedBox(width: 4),
                      Text('Verified', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$proposals proposals',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  timePosted,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
