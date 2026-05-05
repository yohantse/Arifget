enum UserRole {
  freelancer,
  courseBuyer,
  courseSeller,
  client,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.freelancer:
        return 'Freelancer';
      case UserRole.courseBuyer:
        return 'Course Buyer';
      case UserRole.courseSeller:
        return 'Instructor';
      case UserRole.client:
        return 'Client';
    }
  }

  String get tabLabel {
    switch (this) {
      case UserRole.freelancer:
        return 'Jobs';
      case UserRole.courseBuyer:
        return 'Courses';
      case UserRole.courseSeller:
        return 'My Courses';
      case UserRole.client:
        return 'My Posts';
    }
  }
}
