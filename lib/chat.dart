import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

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
  final dio = Dio();
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

  void _submitText(String text, String id) async {
    //String? content;
    bool append = false;
    widget.myController.clear();

    setState(() {
      widget.addMsg({"role": "user", "content": text});
    });

    try {
      //final response = await dio.post(url, data: {"content": text});
      //final response = await widget.dio.post(url, data: widget.messagesVal_);
      content = '';
      final response = await widget.dio.post(
        url,
        data: widget.messagesVal_,
        options: Options(responseType: ResponseType.stream),
      );
      // if (response.statusCode == 200) {
      //   content = response.data["choices"][0]["message"]["content"];
      //   var token = response.data["usage"]["total_tokens"].toString();
      //   widget.tokenSpent_ = "$token/4096";
      //   tokenSpent_ = "$token/4096";
      // } else {
      //   content = response.data;
      // }
      response.data?.stream.listen((event) {
        content += utf8.decode(event);
        widget.onReceivedMsg(id, tokenSpent_, append);
        append = true;
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
