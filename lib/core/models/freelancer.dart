class Freelancer {
  final String id;
  final String name;
  final String? email;
  final String? profilePicUrl;
  final String? title;
  final String? bio;
  final double? hourlyRate;
  final double rating;
  final int reviewsCount;
  final List<String> skills;
  final String? experienceLevel;

  Freelancer({
    required this.id,
    required this.name,
    this.email,
    this.profilePicUrl,
    this.title,
    this.bio,
    this.hourlyRate,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.skills = const [],
    this.experienceLevel,
  });

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'],
      profilePicUrl: json['profile_pic'],
      title: json['freelancer_profile']?['title'],
      bio: json['freelancer_profile']?['overview'],
      hourlyRate: json['freelancer_profile']?['hourly_rate'] != null ? double.tryParse(json['freelancer_profile']!['hourly_rate'].toString()) : null,
      rating: json['freelancer_profile']?['average_rating'] != null ? (double.tryParse(json['freelancer_profile']!['average_rating'].toString()) ?? 0.0) : 0.0,
      reviewsCount: json['freelancer_profile']?['reviews_count'] != null ? (int.tryParse(json['freelancer_profile']!['reviews_count'].toString()) ?? 0) : 0,
      skills: (json['freelancer_profile']?['skills'] as List?)?.map((s) => s.toString()).toList() ?? [],
      experienceLevel: json['freelancer_profile']?['experience_level'],
    );
  }
}
