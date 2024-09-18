import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> details = [1, 2, 3, 4, 5];
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: ListView.builder(
          itemCount: details.length,
          itemBuilder: (context, index) {
            final item = details[index];
            return ElevatedButton(
              onPressed: () => context.go('/details/$item'),
              child: Text('See Detail $item'),
            );
          },
        ),
      ),
    );
  }
}
