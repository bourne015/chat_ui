import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/chat_page.dart';
import './utils/utils.dart';
import './utils/constants.dart';
import './views/app_bar.dart';
import './views/drawer.dart';
import '../models/pages.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    if (isDisplayDesktop(context)) {
      return buildDesktop(context);
    } else {
      return Scaffold(
        backgroundColor: AppColors.chatPageBackground,
        appBar: const MyAppBar(),
        drawer: const ChatDrawer(),
        body: const ChatPage(),
      );
    }
  }

  Widget buildDesktop(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Row(children: <Widget>[
      if (pages.isDrawerOpen) const ChatDrawer(),
      const VerticalDivider(width: 1),
      Expanded(
          child: Scaffold(
        backgroundColor: AppColors.chatPageBackground,
        appBar: const MyAppBar(),
        body: const Row(
          children: <Widget>[
            Expanded(flex: 8, child: ChatPage()),
          ],
        ),
      ))
    ]);
  }
}
