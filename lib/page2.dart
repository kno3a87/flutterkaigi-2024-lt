import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page2 AppBar'),
      ),
      body: ListView.builder(
        itemCount: 200,
        itemBuilder: (_, index) => ListTile(title: Text('Page2 ${index + 1}')),
      ),
    );
  }
}
