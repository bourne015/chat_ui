import 'package:flutter/material.dart';

import "home.dart";

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
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
        fontFamily: "GalleryIcons",
        primarySwatch: Colors.blueGrey,
      ),
      home: const InitPage(),
    );
  }
}
