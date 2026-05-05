import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class JobDetailsPage extends StatelessWidget {
  final String title;
  final double budget;
  final String description;

  const JobDetailsPage({
    super.key,
    required this.title,
    required this.budget,
    this.description = 'We are looking for a highly skilled professional to join our project. The ideal candidate should have extensive experience in the field and a strong portfolio of previous work. You will be responsible for delivering high-quality results within the specified deadline.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobHeader(),
            _buildJobDescription(),
            _buildSkillsRequired(),
            _buildClientInfo(),
            const SizedBox(height: 100), // Space for sticky button
          ],
        ),
      ),
      bottomSheet: _buildSubmitSection(context),
    );
  }

  Widget _buildJobHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Design', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const Spacer(),
              const Text('Posted 2h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(Icons.payments_outlined, 'ETB $budget', 'Fixed Price'),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.bar_chart, 'Intermediate', 'Experience'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildJobDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Job Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(height: 1.5, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsRequired() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skills Required', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillChip('UI Design'),
              _buildSkillChip('Figma'),
              _buildSkillChip('Flutter'),
              _buildSkillChip('Mobile App Development'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[100],
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildClientInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200] ?? Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About the Client', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.verified, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Text('Payment Verified', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('Addis Ababa, Ethiopia', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.work_outline, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('12 jobs posted', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showProposalSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit Proposal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProposalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Submit Proposal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Your Bid (ETB)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Cover Letter',
                hintText: 'Describe why you are the best fit for this job...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proposal submitted successfully!')),
                  );
                },
                child: const Text('Send Proposal'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
