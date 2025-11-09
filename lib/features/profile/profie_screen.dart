import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const ProfileScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: onToggleTheme,
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            size: 25,
            
            ),
          label: Text(
            isDark ? 'Light Mode' : 'Dark Mode',style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
