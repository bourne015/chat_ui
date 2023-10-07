import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import '../utils/constants.dart';
import '../models/pages.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);
  @override
  State<MyAppBar> createState() => MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MyAppBarState extends State<MyAppBar> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return AppBar(
      leading: appbarLeading(context, pages),
      title: appbarTitle(context),
      actions: appbarActions(context, pages),
    );
  }

  List<Widget> appbarActions(BuildContext context, Pages pages) {
    return [
      CupertinoSlidingSegmentedControl<String>(
        thumbColor: AppColors.modelSelected,
        backgroundColor: AppColors.modelSelectorBackground,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        // This represents a currently selected segmented control.
        groupValue: pages.modelVersion,
        // Callback that sets the selected segmented control.
        onValueChanged: (String? value) {
          pages.modelVersion = value;
        },
        children: const <String, Widget>{
          ModelVersion.gptv35: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text('GPT-3.5'),
          ),
          ModelVersion.gptv40: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text('GPT-4.0'),
          ),
        },
      ),
      IconButton(
          tooltip: "About",
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text(aboutText)));
          },
          icon: const Icon(Icons.info))
    ];
  }

  Widget appbarTitle(BuildContext context) {
    return RichText(
        text: const TextSpan(
            text: "Chat",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.chatPageTitle),
            children: [
          TextSpan(
              text: "",
              style: TextStyle(
                  fontSize: 9.5,
                  //fontStyle: FontStyle.normal,
                  color: AppColors.chatPageTitleToken))
        ]));
  }

  Widget appbarLeading(BuildContext context, Pages pages) {
    return IconButton(
      icon: isDisplayDesktop(context)
          ? Icon(pages.isDrawerOpen ? Icons.menu_open : Icons.chevron_right)
          : const Icon(Icons.menu),
      onPressed: () {
        if (isDisplayDesktop(context)) {
          pages.isDrawerOpen = !pages.isDrawerOpen;
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
}
