import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final myController = TextEditingController();
  final List<Widget> messages_ = [];
  final List<Map> messagesVal_ = [];
  final dio = Dio();
  String url = "http://";

  void _submitText(String text) async {
    myController.clear();
    messagesVal_.add({"role": "user", "content": text});
    setState(() {
      messages_.insert(
          0,
          Container(
            alignment: Alignment.centerRight,
            //child: MessageBox(content: text, role: "user"),
            child: MessageBox(val: messagesVal_.last),
          ));
    });

    //final response = await dio.post(url, data: {"content": text});
    final response = await dio.post(url, data: messagesVal_);
    final result = response.data.toString();
    messagesVal_.add({"role": "assistant", "content": result});
    setState(() {
      messages_.insert(
          0,
          Container(
            alignment: Alignment.centerRight,
            child: MessageBox(val: messagesVal_.last),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (context, index) => messages_[index],
              itemCount: messages_.length,
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: const OutlineInputBorder(),
                        hintText: 'Type your message here'),
                    controller: myController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _submitText(myController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                  color: val['role'] == "user"
                      ? Colors.lightGreenAccent[700]
                      : Colors.white,
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
