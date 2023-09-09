import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:html';

import 'utils.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {Key? key,
      required this.id,
      required this.onTokenChanged,
      required this.onReceivedMsg})
      : super(key: key);

  final String id;
  final Function onReceivedMsg;
  final Function onTokenChanged;

  List<Widget> messages_ = [];
  List<Map> messagesVal_ = [];
  var myController = TextEditingController();
  String tokenSpent_ = '';

  void clearMessages() {
    messages_.clear();
    messagesVal_.clear();
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
    var val = {"role": "assistant", "content": content};
    messagesVal_[messagesVal_.length - 1]["content"] = content;
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
  String url = "http://";
  String content = '';
  String tokenSpent_ = '';
  String selectModel = 'gpt35';

  static currentState() {
    var state = ChatBody.chatKey.currentContext?.findAncestorStateOfType();
    return state;
  }

  void refreshMessages() {
    setState(() {});
  }

  void handleMessages(chatPages, id, append) {
    setState(() {
      for (var page in chatPages) {
        if (page.id == id) {
          if (append == false) {
            page.addMsg({"role": "assistant", "content": content});
          } else {
            page.appMsg(content);
          }
          //page.setToken(tokenSpent_);
          //widget.onTokenChanged(id);
          break;
        }
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
              color: Colors.grey[300],
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
                      fillColor: Colors.blue[50],
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

  Stream<String> connect(String path, String method,
      {Map<String, dynamic>? headers, String? body}) {
    int progress = 0;
    //const asciiEncoder = AsciiEncoder();
    final httpRequest = HttpRequest();
    final streamController = StreamController<String>();
    httpRequest.open(method, path);
    headers?.forEach((key, value) {
      httpRequest.setRequestHeader(key, value);
    });
    //httpRequest.onProgress.listen((event) {
    httpRequest.addEventListener('progress', (event) {
      final data = httpRequest.responseText!.substring(progress);

      var lines = data.split("\r\n\r");
      for (var line in lines) {
        line = line.trimLeft();
        for (var vline in line.split('\n')) {
          if (vline.startsWith("data:")) {
            vline = vline.substring(5).replaceFirst(' ', '');
            streamController.add(vline);
          }
        }
      }

      progress += data.length;
    });
    httpRequest.addEventListener('loadstart', (event) {
      debugPrint("event start");
    });
    httpRequest.addEventListener('load', (event) {
      debugPrint("event load");
    });
    httpRequest.addEventListener('loadend', (event) {
      httpRequest.abort();
      streamController.close();
      debugPrint("event end");
    });
    httpRequest.addEventListener('error', (event) {
      streamController.addError(
        httpRequest.responseText ?? httpRequest.status ?? 'err',
      );
      debugPrint("event error");
    });
    httpRequest.send(body);
    return streamController.stream;
  }

  void _submitText(String text, String id) async {
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
      final stream = connect(
        url,
        "POST",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream'
        },
        body: jsonEncode(chatData),
      );
      stream.listen((data) {
        content += data;
        widget.onReceivedMsg(id, tokenSpent_, append);
        append = true;
      }, onError: (e) {
        debugPrint('SSE error: $e');
      }, onDone: () {
        debugPrint('SSE complete');
      });
    } catch (e) {
      content = e.toString();
      widget.onReceivedMsg(id, tokenSpent_, false);
    }
    //widget.onReceivedMsg(id, tokenSpent_);
  }
}

class MessageBox extends StatelessWidget {
  //final String role;
  //final String content
  final Map val;

  const MessageBox({super.key, required this.val});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(val['role'] == "user" ? Icons.person : Icons.perm_identity,
              size: 32),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color:
                      val['role'] == "user" ? Colors.purple[400] : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  )),
              child: SelectableText(val['content'],
                  //overflow: TextOverflow.ellipsis,
                  //showCursor: false,
                  maxLines: null,
                  style: const TextStyle(fontSize: 18.0, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
