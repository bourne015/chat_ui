import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'chat.dart';
import 'utils.dart';
import 'constants.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  Map<int, ChatPage> chatPages = {};
  late ChatPage chatPage;
  late int selectedChatPageId = 0;
  late int maxChatPageId = 0;
  late String tokenTitle = '';
  GPT _selectedSegment = defaultModel;
  bool _isDrawerOpen = true;

  @override
  Widget build(BuildContext context) {
    chatPage = chatPages[selectedChatPageId]!;
    if (isDisplayDesktop(context)) {
      return buildDesktop(context);
    }
    return Scaffold(
      backgroundColor: AppColors.chatPageBackground,
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: chatPage,
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Row(children: <Widget>[
      if (_isDrawerOpen) buildDrawer(context),
      const VerticalDivider(width: 1),
      Expanded(
          child: Scaffold(
        backgroundColor: AppColors.chatPageBackground,
        appBar: buildAppBar(context),
        body: Row(
          children: <Widget>[
            Expanded(flex: 8, child: chatPage),
          ],
        ),
      ))
    ]);
  }

  @override
  void initState() {
    super.initState();
    chatPages[0] = ChatPage(
        id: 0,
        onTokenChanged: handleTokenChange,
        onTitleSummary: handleTitleSummary,
        doneTitleSummary: handledoneTitleSummary,
        onReceivedMsg: handleReceiveMsg);
    chatPage = chatPages[0]!;
    selectedChatPageId = chatPage.id;
  }

  void refreshChat() {
    ChatBody.currentState()?.refreshMessages();
  }

  void handleTokenChange(val) {
    if (val == selectedChatPageId) {
      setState(() {
        //tokenTitle = chatPage.tokenSpent_;
      });
    }
  }

  void handleTitleSummary(id) {
    ChatBody.currentState()?.handleTitleSummary(chatPages, id);
  }

  void handledoneTitleSummary() {
    setState(() {});
  }

  void handleReceiveMsg(id, token, append, data) {
    ChatBody.currentState()?.handleMessages(chatPages, id, append, data);
    // setState(() {
    //   tokenTitle = token;
    // });
  }

  void resetModel() {
    ChatBody.currentState()?.setGptModel(_selectedSegment);
  }

  void updateChatPage(int id) {
    setState(() {
      chatPage = chatPages[id]!;
      selectedChatPageId = id;
      //tokenTitle = chatPage.tokenSpent_;
    });
  }

  String getChatPageTitle(id) {
    final tpage = chatPages[id]!;
    if (tpage.titleSummerized) {
      return tpage.title;
    } else {
      return "Chat $id";
    }
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: isDisplayDesktop(context)
                ? Icon(_isDrawerOpen ? Icons.menu_open : Icons.chevron_right)
                : const Icon(Icons.menu),
            onPressed: () => setState(() {
              if (isDisplayDesktop(context)) {
                _isDrawerOpen = !_isDrawerOpen;
              } else {
                Scaffold.of(context).openDrawer();
              }
            }),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: RichText(
          text: TextSpan(
              text: "Chat", //getChatPageTitle(),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.chatPageTitle),
              children: [
            TextSpan(
                text: selectedChatPageId == chatPage.id
                    ? chatPage.tokenSpent_
                    : "",
                style: const TextStyle(
                    fontSize: 9.5,
                    //fontStyle: FontStyle.normal,
                    color: AppColors.chatPageTitleToken))
          ])),
      actions: <Widget>[
        CupertinoSlidingSegmentedControl<GPT>(
          thumbColor: AppColors.modelSelected,
          backgroundColor: AppColors.modelSelectorBackground,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          // This represents a currently selected segmented control.
          groupValue: _selectedSegment,
          // Callback that sets the selected segmented control.
          onValueChanged: (GPT? value) {
            setState(() {
              _selectedSegment = value!;
              resetModel();
            });
          },
          children: const <GPT, Widget>{
            GPT.v35: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text('GPT-3.5'),
            ),
            GPT.v40: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text('GPT-4.0'),
            ),
          },
        ),
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
    var chatIDs = chatPages.keys.toList();
    return Drawer(
      width: drawerWidth,
      child: Column(
        //padding: EdgeInsets.zero,
        children: <Widget>[
          // const DrawerHeader(
          //   margin: EdgeInsets.all(8),
          //   padding: EdgeInsets.fromLTRB(16, 16, 8, 8),
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text('side bar title'),
          // ),
          Container(
              margin: const EdgeInsets.all(10.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  final newId = ++maxChatPageId;
                  final newPage = ChatPage(
                      id: newId,
                      onTokenChanged: handleTokenChange,
                      onTitleSummary: handleTitleSummary,
                      doneTitleSummary: handledoneTitleSummary,
                      onReceivedMsg: handleReceiveMsg);
                  chatPages[newId] = newPage;
                  updateChatPage(newPage.id);
                  if (!isDisplayDesktop(context)) Navigator.pop(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('New Chat'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 60)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  //padding: EdgeInsets.symmetric(horizontal: 20.0),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                ),
              )),
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: chatIDs.length,
              itemBuilder: (context, index) {
                final page = chatPages[chatIDs[index]]!;
                return Container(
                    margin: const EdgeInsets.fromLTRB(8.0, 0, 10, 0),
                    child: ListTile(
                      selectedTileColor: AppColors.drawerTabSelected,
                      selected: page.id == selectedChatPageId,
                      leading: const Icon(Icons.chat),
                      minLeadingWidth: 0,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      title: Text(getChatPageTitle(page.id),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1), //Text("Chat ${page.id}"),
                      onTap: () {
                        updateChatPage(page.id);
                        if (!isDisplayDesktop(context)) Navigator.pop(context);
                      },
                      //always keep chat 0
                      trailing: chatIDs[index] > 0
                          ? Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                iconSize: 20,
                                onPressed: () {
                                  var removeId = page.id;
                                  chatPages.remove(removeId);
                                  if (removeId == selectedChatPageId) {
                                    updateChatPage(chatPages[0]!.id);
                                  }
                                  setState(() {});
                                },
                              ),
                            ])
                          : null,
                    ));
              },
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: AppColors.drawerDivider,
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                minLeadingWidth: 0,
                title: const Text('Clear Conversations'),
                onTap: () {
                  setState(() {
                    chatPages[selectedChatPageId]!.clearMessages();
                    chatPages[selectedChatPageId]!.setToken("");
                    //updateChatPage(selectedChatPageId);
                    refreshChat();
                  });
                  if (!isDisplayDesktop(context)) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                minLeadingWidth: 0,
                title: const Text('Log out'),
                onTap: () {
                  if (!isDisplayDesktop(context)) {
                    Navigator.pop(context); // hide sidebar
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
