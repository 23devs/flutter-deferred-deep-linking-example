import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String? id;
  const DetailScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail ${id ?? ''}')),
      body: Center(
        child: Text('Detail ${id ?? ''} description'),
      ),
    );
  }
}
