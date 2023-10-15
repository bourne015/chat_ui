import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pages.dart';
import './input_field.dart';
import '../utils/utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Column(children: [
      if (isDisplayDesktop(context) && !pages.isDrawerOpen)
        drawerButton(context),
      messageList(context),
      const ChatInputField(),
    ]);
  }

  Widget drawerButton(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Row(children: [
      Container(
          margin: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          child: OutlinedButton(
            onPressed: () {
              if (isDisplayDesktop(context)) {
                pages.isDrawerOpen = !pages.isDrawerOpen;
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(52, 52)),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
            ),
            child: const Icon(Icons.amp_stories_outlined),
          ))
    ]);
  }

  Widget messageList(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    final msgBoxes = pages.getMessageBox(pages.currentPageID);
    return Flexible(
      child: ListView.builder(
        key: UniqueKey(),
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (context, index) => msgBoxes?[index],
        itemCount: msgBoxes?.length,
      ),
    );
  }
}
