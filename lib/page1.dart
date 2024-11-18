import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    // スクロールバーだしたり無限スクロールするときとかに使う
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          key: const PageStorageKey('page1'),
          controller: scrollController,
          itemCount: 100,
          itemBuilder: (_, index) =>
              ListTile(title: Text('Page1 ${index + 1}')),
        ),
      ),
    );
  }
}
