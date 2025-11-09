import 'package:flutter/material.dart';
import 'package:stockmark/core/app_routes.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.detail);
          },
          child: Text("News Detail", style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
