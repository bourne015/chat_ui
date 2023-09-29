import 'package:flutter/material.dart';

import 'home.dart';
import 'routes.dart' as routes;
import 'constants.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  static const String homeRoute = routes.homeRoute;

  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _AppState();
}

class _AppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        fontFamily: 'notosanssc',
        primarySwatch: AppColors.titleBar,
      ),
      initialRoute: ChatApp.homeRoute,
      routes: {
        ChatApp.homeRoute: (context) => const InitPage(),
      },
    );
  }
}
