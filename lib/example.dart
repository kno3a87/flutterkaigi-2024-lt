import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/page1.dart';
import 'package:flutterkaigi_2024_lt/page2.dart';

class Example extends StatefulWidget {
  const Example({super.key, required this.title});

  final String title;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          Page1(),
          Page2(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Page 2',
          ),
        ],
      ),
    );
  }
}
