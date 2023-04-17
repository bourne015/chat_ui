import 'package:flutter/material.dart';
import 'package:mychat/chat.dart';

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
      home: const InitPage(),
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State createState() => ChatPageState();
}

class ChatPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    const chatPage = ChatPage();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: chatPage,
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: RichText(
          text: const TextSpan(children: [
        TextSpan(
            text: "Chat  ",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        // TextSpan(
        //     text: chatPage.,
        //     style: const TextStyle(
        //         fontSize: 9.5,
        //         //fontStyle: FontStyle.normal,
        //         color: Colors.grey))
      ])),
      actions: <Widget>[
        IconButton(
            tooltip: "About",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("A Demo for ChatGPT-3.5, the token is limited, "
                      "Please refresh the page if reached max tokens"
                      "or don't need question context")));
            },
            icon: const Icon(Icons.info))
      ],
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        //padding: EdgeInsets.zero,
        children: <Widget>[
          // const DrawerHeader(
          //   margin: EdgeInsets.all(8),
          //   padding: EdgeInsets.fromLTRB(16, 16, 8, 8),
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text('侧边栏标题'),
          // ),
          Column(
            children: [
              ListTile(
                title: const Text('New Chat'),
                onTap: () {
                  //_addChatPage;
                },
              ),
            ],
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Color.fromARGB(255, 186, 182, 182),
          ),
          Flexible(
            child: ListView(),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Color.fromARGB(255, 186, 182, 182),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Reset'),
                onTap: () {
                  //Navigator.pop(context);
                  // setState(() {
                  //   messages_.clear();
                  // });
                },
              ),
              ListTile(
                title: const Text('Log out'),
                onTap: () {
                  Navigator.pop(context); // hide sidebar
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
