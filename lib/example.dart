import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Example extends StatefulWidget {
  final Widget child;

  const Example({super.key, required this.child});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });

          switch (value) {
            case 0:
              context.go('/page1');
              break;
            case 1:
              context.go('/page2');
              break;
          }
        },
      ),
    );
  }
}
