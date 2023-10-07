import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/pages.dart';
import '../utils/constants.dart';
import '../models/message.dart';
import '../utils/utils.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final dio = Dio();
  final ChatSSE chatServer = ChatSSE();
  final _controller = TextEditingController();
  bool _hasInputContent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.inputBoxBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 15),
      padding: const EdgeInsets.only(left: 15, right: 5, top: 1, bottom: 1),
      child: Row(
        children: [
          inputField(context),
          sendButton(context),
        ],
      ),
    );
  }

  Widget inputField(BuildContext context) {
    return Expanded(
      child: TextField(
        onChanged: (value) {
          setState(() {
            _hasInputContent = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputTextField,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )),
            hintText: 'Send a message'),
        minLines: 1,
        maxLines: 10,
        textInputAction: TextInputAction.newline,
        controller: _controller,
      ),
    );
  }

  Widget sendButton(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return IconButton(
      icon: const Icon(Icons.send),
      color: (_hasInputContent && !pages.currentPage!.onGenerating)
          ? Colors.blue
          : Colors.grey,
      onPressed: (_hasInputContent && !pages.currentPage!.onGenerating)
          ? () => {
                _submitText(
                  pages,
                  pages.currentPageID,
                  _controller.text,
                ),
                _hasInputContent = false
              }
          : null,
    );
  }

  void titleSummery(Pages pages, int hanglePageID) async {
    String q = pages.getMessages(hanglePageID)![1].content;
    var chatData1 = {
      "model": pages.modelVersion,
      "question": "为这段话写一个5个字左右的标题:$q"
    };
    final response = await dio.post(url1Chat, data: chatData1);
    var title = response.data["choices"][0]["message"]["content"];
    pages.setPageTitle(hanglePageID, title);
  }

  void _submitText(Pages pages, int hanglePageID, String text) async {
    bool append = false;
    _controller.clear();
    Message msgQ = Message(
        id: '0',
        pageID: hanglePageID,
        role: MessageRole.user,
        content: text,
        timestamp: DateTime.now());
    pages.addMessage(hanglePageID, msgQ);

    try {
      var chatData = {
        "model": pages.modelVersion,
        "question": pages.getPage(hanglePageID).msgsToMap()
      };
      final stream = chatServer.connect(
        urlSSE,
        "POST",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream'
        },
        body: jsonEncode(chatData),
      );
      stream.listen((data) {
        if (append == false) {
          Message msgA = Message(
              id: '1',
              pageID: hanglePageID,
              role: MessageRole.assistant,
              content: data,
              timestamp: DateTime.now());
          pages.addMessage(hanglePageID, msgA);
        } else {
          pages.appendMessage(hanglePageID, data);
        }
        pages.currentPage?.onGenerating = true;
        append = true;
      }, onError: (e) {
        debugPrint('SSE error: $e');
        pages.getPage(hanglePageID).onGenerating = false;
      }, onDone: () {
        debugPrint('SSE complete');
        if (pages.getPage(hanglePageID).title == "chat $hanglePageID") {
          titleSummery(pages, hanglePageID);
        }
        pages.getPage(hanglePageID).onGenerating = false;
      });
    } catch (e) {
      debugPrint("error: $e");
      pages.getPage(hanglePageID).onGenerating = false;
    }
  }
}
