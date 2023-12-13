import 'package:flutter/material.dart';

import 'message.dart';
import '../views/message_box.dart';
import '../utils/constants.dart';

//model of a chat page
class Chat {
  final int id;
  List<Message> messages = [];
  List<Widget> messageBox = [];
  List<Map> msg = [];

  String title;
  String _modelVersion = '';
  int tokenSpent = 0;
  bool onGenerating = false;

  Chat({
    required int chatId,
    String? title,
  })  : id = chatId,
        title = title!;

  String get modelVersion => _modelVersion;

  set modelVersion(String? v) {
    _modelVersion = v!;
    //notifyListeners();
  }

  void addMessage(Message newMsg) {
    messages.add(newMsg);
    messageBox.insert(
        0,
        Container(
          alignment: Alignment.centerRight,
          child: MessageBox(val: {
            "role": newMsg.role,
            "type": newMsg.type,
            "content": newMsg.content,
            "file": newMsg.file
          }),
        ));
  }

  void appendMessage(String newMsg) {
    int lastMsgID = messages.isNotEmpty ? messages.length - 1 : 0;
    messages[lastMsgID].content += newMsg;
    messageBox[0] = Container(
      alignment: Alignment.centerRight,
      child: MessageBox(val: {
        "role": MessageRole.assistant,
        "content": messages[lastMsgID].content
      }),
    );
  }

  List<Map> msgsToMap() {
    List<Map> res = [];
    for (int i = 0; i < messages.length; i++) {
      var val = messages[i];
      res.add(val.toMap());
    }
    msg = res;
    return msg;
  }
}
