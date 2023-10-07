import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pages.dart';
import './input_field.dart';

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
    final msgBox = pages.getMessageBox(pages.currentPageID);
    return Column(children: [
      Flexible(
          child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/chatgpt_red.png"))),
        child: ListView.builder(
          key: UniqueKey(),
          padding: const EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (context, index) => msgBox?[index],
          itemCount: msgBox?.length,
        ),
      )),
      const ChatInputField(),
    ]);
  }
}
