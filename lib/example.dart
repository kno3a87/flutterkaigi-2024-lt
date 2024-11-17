import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/widgets/emoji.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: emojiScaledTextSpan(
              text: 'Hello✌️FlutterKaigi🦆2024🔥LT👫',
              style: const TextStyle(fontSize: 17),
              originalFontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
