import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../utils/utils.dart';
import '../models/pages.dart';
import '../models/chat.dart';

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => ChatDrawerState();
}

class ChatDrawerState extends State<ChatDrawer> {
  @override
  Widget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Drawer(
      width: drawerWidth,
      child: Column(
        //padding: EdgeInsets.zero,
        children: <Widget>[
          newchatButton(context),
          chatPageTabList(context),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: AppColors.drawerDivider,
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            minLeadingWidth: 0,
            title: const Text('Clear Conversations'),
            onTap: () {
              if (pages.currentPage?.onGenerating == false) {
                pages.clearMsg(pages.currentPageID);
              }
              pages.currentPage?.title = "Chat ${pages.currentPage?.id}";
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
    );
  }

  Widget newchatButton(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: OutlinedButton.icon(
          onPressed: () {
            var newId = pages.assignNewPageID;
            pages.addPage(newId, Chat(chatId: newId, title: "Chat $newId"));
            pages.currentPageID = newId;
            if (!isDisplayDesktop(context)) Navigator.pop(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('New Chat'),
          style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 55)),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            //padding: EdgeInsets.symmetric(horizontal: 20.0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
        ));
  }

  Widget delChattabButton(BuildContext context, Pages pages, int removeID) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: const Icon(Icons.close),
        iconSize: 20,
        onPressed: () {
          pages.delPage(removeID);
          pages.currentPageID = 0;
        },
      ),
    ]);
  }

  Widget chatPageTab(BuildContext context, Pages pages, int index) {
    final page = pages.getPage(pages.getNthPageID(index));
    return Container(
        margin: const EdgeInsets.fromLTRB(8.0, 0, 10, 0),
        child: ListTile(
          selectedTileColor: AppColors.drawerTabSelected,
          selected: pages.currentPageID == page.id,
          leading: const Icon(Icons.chat_bubble_outline, size: 18),
          minLeadingWidth: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Text(page.title, overflow: TextOverflow.ellipsis, maxLines: 1),
          onTap: () {
            pages.currentPageID = page.id;
            if (!isDisplayDesktop(context)) Navigator.pop(context);
          },
          //always keep chat 0
          trailing: (pages.currentPageID == page.id && pages.pagesLen > 1)
              ? delChattabButton(context, pages, page.id)
              : null,
        ));
  }

  Widget chatPageTabList(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Expanded(
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: pages.pagesLen,
        itemBuilder: (context, index) => chatPageTab(context, pages, index),
      ),
    );
  }
}
