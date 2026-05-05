import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'main_wrapper.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
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
    themeNotifier.addListener(_updateTheme);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_updateTheme);
    super.dispose();
  }

  void _updateTheme() {
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
      home: const MainWrapper(),
    );
  }
}
