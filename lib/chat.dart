import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'utils.dart';
import 'constants.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {Key? key,
      required this.id,
      required this.onTokenChanged,
      required this.onTitleSummary,
      required this.doneTitleSummary,
      required this.onReceivedMsg})
      : super(key: key);

  final int id;
  final Function onReceivedMsg;
  final Function onTitleSummary;
  final Function doneTitleSummary;
  final Function onTokenChanged;

  List<Widget> messages_ = [];
  List<Map> messagesVal_ = [];
  var myController = TextEditingController();
  String tokenSpent_ = '';
  final dio = Dio();
  String title = '';
  bool titleSummerized = false;

  void clearMessages() {
    messages_.clear();
    messagesVal_.clear();
    titleSummerized = false;
  }

  void setToken(val) {
    tokenSpent_ = val;
  }

  void addMsg(val) {
    messagesVal_.add(val);
    messages_.insert(
        0,
        Container(
          alignment: Alignment.centerRight,
          child: MessageBox(val: val),
        ));
  }

  void appMsg(content) {
    messagesVal_[messagesVal_.length - 1]["content"] += content;
    var val = {
      "role": "assistant",
      "content": messagesVal_[messagesVal_.length - 1]["content"]
    };
    messages_[0] = Container(
      alignment: Alignment.centerRight,
      child: MessageBox(val: val),
    );
  }

  @override
  State createState() => ChatBody();
}

class ChatBody extends State<ChatPage> {
  static GlobalKey chatKey = GlobalKey();
  String content = '';
  String tokenSpent_ = '';
  String selectModel = 'gpt35';
  ChatSSE conn_chat = ChatSSE();

  static currentState() {
    var state = ChatBody.chatKey.currentContext?.findAncestorStateOfType();
    return state;
  }

  void refreshMessages() {
    setState(() {});
  }

  void handleTitleSummary(chatPages, id) {
    if (chatPages.containsKey(id) && !chatPages[id].titleSummerized) {
      titleSummery(
          chatPages[id].messagesVal_[chatPages[id].messagesVal_.length - 1]
              ["content"],
          chatPages[id]);
    }
  }

  void handleMessages(chatPages, id, append, data) {
    setState(() {
      if (chatPages.containsKey(id)) {
        if (append == false) {
          chatPages[id].addMsg({"role": "assistant", "content": data});
        } else {
          chatPages[id].appMsg(data);
        }
        //page.setToken(tokenSpent_);
        //widget.onTokenChanged(id);
      }
    });
  }

  void setGptModel(GPT modelVersion) {
    if (modelVersion == GPT.v40) {
      selectModel = 'gpt40';
    } else {
      selectModel = 'gpt35';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: chatKey,
      children: [
        Flexible(
            child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/chatgpt_red.png"))),
          child: ListView.builder(
            key: UniqueKey(),
            padding: const EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (context, index) => widget.messages_[index],
            itemCount: widget.messages_.length,
          ),
        )),
        Container(
          decoration: BoxDecoration(
              color: AppColors.inputBoxBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          margin:
              const EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 15),
          padding: const EdgeInsets.only(left: 15, right: 5, top: 1, bottom: 1),
          child: Row(
            children: [
              Expanded(
                child: TextField(
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
                      hintText: 'Type your message here'),
                  minLines: 1,
                  maxLines: 10,
                  textInputAction: TextInputAction.newline,
                  controller: widget.myController,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _submitText(
                  widget.myController.text,
                  widget.id,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void titleSummery(chatAnswer_1, page) async {
    var chatData1 = {
      "model": selectModel,
      "question": "为这段话写一个5个字左右的标题:$chatAnswer_1"
    };
    final response = await widget.dio.post(url1Chat, data: chatData1);
    page.title = response.data["choices"][0]["message"]["content"];
    page.titleSummerized = true;
    widget.doneTitleSummary();
  }

  void _submitText(String text, int id) async {
    //String? content;
    bool append = false;
    widget.myController.clear();

    setState(() {
      widget.addMsg({"role": "user", "content": text});
    });

    try {
      content = '';
      //   var token = response.data["usage"]["total_tokens"].toString();
      //   widget.tokenSpent_ = "$token/4096";
      //   tokenSpent_ = "$token/4096";

      var chatData = {"model": selectModel, "question": widget.messagesVal_};
      final stream = conn_chat.connect(
        urlSSE,
        "POST",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream'
        },
        body: jsonEncode(chatData),
      );
      stream.listen((data) {
        //content += data;
        widget.onReceivedMsg(id, tokenSpent_, append, data);
        append = true;
      }, onError: (e) {
        debugPrint('SSE error: $e');
      }, onDone: () {
        debugPrint('SSE complete');
        widget.onTitleSummary(id);
      });
    } catch (e) {
      widget.onReceivedMsg(id, tokenSpent_, false, e.toString());
    }
    //widget.onReceivedMsg(id, tokenSpent_);
  }
}
