import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/chat_page.dart';
import './utils/utils.dart';
import './utils/constants.dart';
import './views/app_bar.dart';
import './views/drawer.dart';
import './models/pages.dart';
import './views/init_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    if (isDisplayDesktop(context)) {
      return buildDesktop(context);
    } else {
      return Scaffold(
        backgroundColor: AppColors.chatPageBackground,
        appBar: const MyAppBar(),
        drawer: const ChatDrawer(),
        body: pages.displayInitPage ? buildInitPage(context) : const ChatPage(),
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
        //appBar: const MyAppBar(),
        body: pages.displayInitPage
            ? buildInitPage(context)
            : buildChatPage(context),
      ))
    ]);
  }

  Widget buildChatPage(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return NestedScrollView(
      floatHeaderSlivers: true,
      scrollDirection: Axis.vertical,

      //physics: ClampingScrollPhysics,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text(
              pages.currentPage!.modelVersion,
              style: const TextStyle(fontSize: 16, color: AppColors.appBarText),
            ),
            pinned: false,
            floating: true,
            snap: true,
            //stretch: true,
            backgroundColor: AppColors.appBarBackground,
          ),
        ];
      },
      body: const Row(
        children: <Widget>[
          Expanded(flex: 8, child: ChatPage()),
        ],
      ),
    );
  }

  Widget buildInitPage(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(flex: 8, child: InitPage()),
      ],
    );
  }
}
