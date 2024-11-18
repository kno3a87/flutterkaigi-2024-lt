import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1 AppBar'),
      ),
      body: ListView.builder(
        itemCount: 200,
        itemBuilder: (_, index) => ListTile(title: Text('Page1 ${index + 1}')),
      ),
    );
  }
}
