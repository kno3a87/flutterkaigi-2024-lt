import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/scroll_wapper.dart';

class Example extends StatefulWidget {
  const Example({super.key, required this.title});

  final String title;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  // スクロールバーだしたり無限スクロールするときとかに使う
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        const snackbar = SnackBar(content: Text('Reached the end of the list'));
        // スクロール末尾に到達したらスナックバーを表示
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollWrapper(
      onTap: () async {
        // ステータスバータップでトップに戻る
        await scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          controller: scrollController, // これを消せばステータスバータップでトップに戻れる
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
        ),
      ),
    );
  }
}
