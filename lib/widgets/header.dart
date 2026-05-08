import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../main.dart';

class Header extends StatelessWidget {
  final Function(String)? onSearchSubmit;

  const Header({super.key, this.onSearchSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
      ),
      child: Row(
        children: [
          // Logo
          Image.asset(
            'logo/arif-logo.png',
            height: 30,
            errorBuilder: (context, error, stackTrace) => const Text(
              'Arifget',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Search Bar (Expanded)
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onSubmitted: onSearchSubmit,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.white60),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Dark Mode Toggle
          IconButton(
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
            color: Colors.white,
            icon: Icon(
              themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
