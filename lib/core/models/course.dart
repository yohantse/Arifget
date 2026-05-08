class Course {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final double price;
  final String? previewImageUrl;
  final String? level;
  final String? instructorName;

  Course({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.price,
    this.previewImageUrl,
    this.level,
    this.instructorName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      description: json['description'],
      price: json['price'] != null ? (double.tryParse(json['price'].toString()) ?? 0.0) : 0.0,
      previewImageUrl: json['course_preview_image_url'],
      level: json['level'],
      instructorName: json['seller']?['name'],
    );
  }
}
