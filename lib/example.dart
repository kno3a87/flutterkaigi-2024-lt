import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key, required this.title});

  final String title;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Stack(
          children: [
            Text(
              'Hello, FlutterKaigi 2024 LT!',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Hello, FlutterKaigi 2024 LT!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
