import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/scroll_wrapper.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  // スクロールバーだしたり無限スクロールするときとかに使う
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        const snackbar = SnackBar(content: Text('Reached the end of the list'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollWrapper(
      onTap: () async {
        await scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        body: ListView.builder(
          key: const PageStorageKey('page2'),
          controller: scrollController, // 消せばステータスバータップでトップに戻れる
          itemCount: 100,
          itemBuilder: (_, index) =>
              ListTile(title: Text('Page2 ${index + 1}')),
        ),
      ),
    );
  }
}
