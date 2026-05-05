import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'main_wrapper.dart';
import 'core/models/user_role.dart';
import 'core/services/auth_service.dart';

import 'pages/login_page.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<UserRole> roleNotifier = ValueNotifier<UserRole>(UserRole.freelancer);
final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Auth Service
  final authService = AuthService();
  await authService.init();
  
  // Check if user is already logged in
  final loggedIn = await authService.checkAuthStatus();
  isLoggedIn.value = loggedIn;
  if (loggedIn && AuthService.userNotifier.value != null) {
    roleNotifier.value = AuthService.userNotifier.value!.defaultRole;
  }
  
  runApp(const ArifgetApp());
}

class ArifgetApp extends StatefulWidget {
  const ArifgetApp({super.key});

  @override
  State<ArifgetApp> createState() => _ArifgetAppState();
}

class _ArifgetAppState extends State<ArifgetApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_update);
    isLoggedIn.addListener(_update);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_update);
    isLoggedIn.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arifget Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.value,
      home: isLoggedIn.value ? const MainWrapper() : const LoginPage(),
    );
  }
}
