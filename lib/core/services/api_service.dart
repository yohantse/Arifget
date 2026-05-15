import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../models/job.dart';
import '../models/freelancer.dart';

class ApiService {
  static const String baseUrl = 'https://api.dev.arifget.com';

  static Future<List<Course>> getCourses({String? query, int page = 1, int limit = 10}) async {
    try {
      String url = '$baseUrl/api/course?page=$page&limit=$limit';
      if (query != null && query.isNotEmpty) {
        url += '&search=$query';
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> coursesJson = data['data'];
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Job>> getJobs({String? query, int page = 1}) async {
    try {
      String url = '$baseUrl/api/jobs?page=$page';
      if (query != null && query.isNotEmpty) {
        url += '&search=$query';
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> jobsJson = data['data'];
        return jobsJson.map((json) => Job.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      rethrow;
    }
  }
  static Future<List<Freelancer>> getFreelancers({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/freelancers?page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> freelancersJson = data['data'];
        return freelancersJson.map((json) => Freelancer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load freelancers');
      }
    } catch (e) {
      rethrow;
    }
  }
}
