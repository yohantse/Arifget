class Job {
  final String id;
  final String title;
  final String description;
  final double? budgetAmount;
  final String? budgetType;
  final String? experienceLevel;
  final String? duration;
  final String? location;
  final DateTime? createdAt;
  final String? displayBudget;

  Job({
    required this.id,
    required this.title,
    required this.description,
    this.budgetAmount,
    this.budgetType,
    this.experienceLevel,
    this.duration,
    this.location,
    this.createdAt,
    this.displayBudget,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      budgetAmount: json['budget_amount'] != null ? double.tryParse(json['budget_amount'].toString()) : null,
      budgetType: json['budget_type'],
      experienceLevel: json['experience_level'],
      duration: json['duration'],
      location: json['location'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      displayBudget: json['display_budget'],
    );
  }
}
