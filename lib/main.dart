import 'package:flutter/material.dart';
import 'package:flutterkaigi_2024_lt/example.dart';
import 'package:flutterkaigi_2024_lt/page1.dart';
import 'package:flutterkaigi_2024_lt/page2.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerConfig = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/page1',
  routes: [
    ShellRoute(
      navigatorKey: rootNavigatorKey,
      builder: (_, __, child) {
        return Example(child: child);
      },
      routes: [
        GoRoute(
          path: '/page1',
          pageBuilder: (_, __) => const MaterialPage(child: Page1()),
        ),
        GoRoute(
          path: '/page2',
          pageBuilder: (_, __) => const MaterialPage(child: Page2()),
        ),
      ],
    ),
  ],
);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
    );
  }
}
