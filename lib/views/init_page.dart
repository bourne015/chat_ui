import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../models/pages.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import './input_field.dart';
import './drawer_button.dart';

class InitPage extends StatefulWidget {
  const InitPage({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Column(children: <Widget>[
      Row(children: [
        if (isDisplayDesktop(context) && !pages.isDrawerOpen)
          const ChatDrawerButton(),
        const Spacer(),
        modelSelectButton(context),
        const Spacer(),
      ]),
      Row(children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            "ChatGPT",
            style: TextStyle(
                color: AppColors.initPageBackgroundText,
                fontSize: 35.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
      ]),
      Expanded(
        child: Container(),
      ),
      const ChatInputField(),
    ]);
  }

  Widget modelSelectButton(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: CupertinoSlidingSegmentedControl<String>(
        thumbColor: AppColors.modelSelected,
        backgroundColor: AppColors.modelSelectorBackground!,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        // This represents a currently selected segmented control.
        groupValue: pages.defaultModelVersion,
        // Callback that sets the selected segmented control.
        onValueChanged: (String? value) {
          pages.defaultModelVersion = value;
        },
        children: <String, Widget>{
          ModelVersion.gptv35: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(children: [
              Icon(
                Icons.flash_on,
                color: pages.defaultModelVersion == 'GPT-3.5'
                    ? Colors.green
                    : Colors.grey,
              ),
              const Text('GPT-3.5')
            ]),
          ),
          ModelVersion.gptv40: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(children: [
              Icon(
                Icons.workspaces,
                color: pages.defaultModelVersion == 'GPT-4.0'
                    ? Colors.purple
                    : Colors.grey,
              ),
              const Text('GPT-4.0')
            ]),
          ),
        },
      ),
    );
  }
}
