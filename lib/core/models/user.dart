import 'user_role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String? gender;
  final String? profilePic;
  final String? phone;
  final List<String> apiRoles; // raw roles from API e.g. ["USER","FREELANCER"]

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
    this.gender,
    this.profilePic,
    this.phone,
    required this.apiRoles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final rawRoles = (json['roles'] as List<dynamic>?)
            ?.map((r) => r.toString())
            .toList() ??
        ['USER'];
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      emailVerified: json['email_verified'] == true,
      gender: json['gender']?.toString(),
      profilePic: json['profile_pic']?.toString(),
      phone: json['phone']?.toString(),
      apiRoles: rawRoles,
    );
  }

  /// Returns initials for avatar placeholder (e.g. "KD" from "Kalkidan Damena")
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  /// Maps API role strings to app UserRole values
  List<UserRole> get appRoles {
    final roles = <UserRole>{};
    for (final r in apiRoles) {
      switch (r.toUpperCase()) {
        case 'FREELANCER':
          roles.add(UserRole.freelancer);
          break;
        case 'CLIENT':
          roles.add(UserRole.client);
          break;
        case 'SELLER':
          roles.add(UserRole.courseSeller);
          break;
        case 'USER':
          roles.add(UserRole.courseBuyer);
          break;
      }
    }
    if (roles.isEmpty) roles.add(UserRole.courseBuyer);
    return roles.toList();
  }

  /// Best default role for this user
  UserRole get defaultRole {
    final roles = appRoles;
    if (roles.contains(UserRole.freelancer)) return UserRole.freelancer;
    if (roles.contains(UserRole.client)) return UserRole.client;
    if (roles.contains(UserRole.courseSeller)) return UserRole.courseSeller;
    return UserRole.courseBuyer;
  }
}
