import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pages.dart';
import '../utils/utils.dart';

class ChatDrawerButton extends StatelessWidget {
  const ChatDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Row(children: [
      Container(
          margin: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          child: OutlinedButton(
            onPressed: () {
              if (isDisplayDesktop(context)) {
                pages.isDrawerOpen = !pages.isDrawerOpen;
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(52, 52)),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
            ),
            child: const Icon(Icons.amp_stories_outlined),
          ))
    ]);
  }
}
