import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'https://api.dev.arifget.com';
  late Dio dio;
  late CookieJar cookieJar;

  /// Holds the currently authenticated user. Null when logged out.
  static final ValueNotifier<User?> userNotifier = ValueNotifier<User?>(null);

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        if (!kIsWeb) 'Origin': baseUrl,
        if (!kIsWeb) 'Referer': '$baseUrl/',
      },
      // Essential for Laravel Sanctum on Web
      extra: {'withCredentials': true},
      validateStatus: (status) => status! < 500,
    ));
  }

  Future<void> init() async {
    if (kIsWeb) {
      // On Web, the browser handles cookies automatically.
      // We don't need PersistCookieJar or path_provider.
      cookieJar = CookieJar(); 
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final cookieDir = Directory("$appDocPath/.cookies/");
      if (!await cookieDir.exists()) {
        await cookieDir.create(recursive: true);
      }
      cookieJar = PersistCookieJar(
        storage: FileStorage(cookieDir.path),
      );
      dio.interceptors.add(CookieManager(cookieJar));
    }
    
    // Add logging interceptor for debugging
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('--- API Request ---');
        print('${options.method}: ${options.uri}');
        print('Headers: ${options.headers}');
        print('Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('--- API Response ---');
        print('Status: ${response.statusCode}');
        print('Body: ${response.data}');
        return handler.next(response);
      },
      onError: (e, handler) {
        print('--- API Error ---');
        print('Status: ${e.response?.statusCode}');
        print('Error: ${e.message}');
        print('Body: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  /// Returns null on success, or an error message string on failure.
  Future<String?> login(String email, String password) async {
    try {
      print('Starting login handshake...');
      // 1. Get CSRF Cookie
      await dio.get('/sanctum/csrf-cookie');

      // Always try to grab the XSRF token from the cookie jar for all platforms
      String? xsrfToken;
      try {
        final cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
        for (var cookie in cookies) {
          if (cookie.name == 'XSRF-TOKEN') {
            xsrfToken = Uri.decodeComponent(cookie.value);
          }
        }
      } catch (e) {
        print('Could not extract XSRF token: $e');
      }

      // 2. Perform Login
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'remember': true,
          'type': 'user',
        },
        options: Options(
          headers: {
            if (xsrfToken != null) 'X-XSRF-TOKEN': xsrfToken,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Login successful!');
        // Parse and store the user from the response
        final body = response.data;
        if (body is Map && body['data'] is Map) {
          userNotifier.value = User.fromJson(body['data'] as Map<String, dynamic>);
        }
        return null; // null = success
      } else {
        final body = response.data;
        final msg = (body is Map)
            ? (body['message'] ?? 'Login failed (${response.statusCode})')
            : 'Login failed (${response.statusCode})';
        print('Login failed: $msg');
        return msg.toString();
      }
    } catch (e) {
      print('Exception during login: $e');
      return 'Connection error. Please check your internet.';
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } finally {
      await cookieJar.deleteAll();
      userNotifier.value = null;
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      final response = await dio.get('/auth/me');
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['data'] is Map) {
          userNotifier.value = User.fromJson(body['data'] as Map<String, dynamic>);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
