import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/scroll_wrapper.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    // スクロールバーだしたり無限スクロールするときとかに使う
    final ScrollController scrollController = ScrollController();

    return ScrollWrapper(
      onTap: () async {
        await scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
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
      ),
    );
  }
}
