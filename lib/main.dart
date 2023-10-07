import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/pages.dart';
import 'main_layout.dart';
import 'routes.dart' as routes;
import 'utils/constants.dart';
import './models/chat.dart';

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
    final pages = Pages();
    var newId = pages.assignNewPageID;
    pages.addPage(newId, Chat(chatId: newId, title: "chat 0"));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => pages),
        ],
        child: MaterialApp(
          title: appTitle,
          theme: ThemeData(
            fontFamily: 'notosanssc',
            primarySwatch: AppColors.titleBar,
          ),
          initialRoute: ChatApp.homeRoute,
          routes: {
            ChatApp.homeRoute: (context) => const MainLayout(),
          },
        ));
  }
}
