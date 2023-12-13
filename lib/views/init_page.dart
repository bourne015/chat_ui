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
  List<String> gpt4Sub = <String>['Basic', 'Vision', 'DALL'];
  String dropdownValue = 'Basic';
  String? selected;

  @override
  Widget build(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);
    if (pages.defaultModelVersion == ModelVersion.gptv35) {
      selected = 'GPT-3.5';
    } else if (pages.defaultModelVersion == ModelVersion.gptv40) {
      selected = 'GPT-4.0';
      dropdownValue = gpt4Sub[0];
    } else if (pages.defaultModelVersion == ModelVersion.gptv40Vision) {
      selected = 'GPT-4.0';
      dropdownValue = gpt4Sub[1];
    } else if (pages.defaultModelVersion == ModelVersion.gptv40Dall) {
      selected = 'GPT-4.0';
      dropdownValue = gpt4Sub[2];
    }
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
        groupValue: selected,
        // Callback that sets the selected segmented control.
        onValueChanged: (String? value) {
          if (value == 'GPT-3.5') {
            pages.defaultModelVersion = ModelVersion.gptv35;
          } else {
            pages.defaultModelVersion = ModelVersion.gptv40;
          }
          selected = value;
        },
        children: <String, Widget>{
          'GPT-3.5': Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Row(children: [
              Icon(
                Icons.flash_on,
                color: pages.defaultModelVersion == ModelVersion.gptv35
                    ? Colors.green
                    : Colors.grey,
              ),
              const Text('GPT-3.5')
            ]),
          ),
          'GPT-4.0': Padding(
            padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
            child: Row(children: [
              Icon(
                Icons.workspaces,
                color: pages.defaultModelVersion != ModelVersion.gptv35
                    ? Colors.purple
                    : Colors.grey,
              ),
              const Text('GPT-4.0'),
              const SizedBox(width: 3),
              if (pages.defaultModelVersion != ModelVersion.gptv35)
                dropdownMenu(context),
            ]),
          ),
        },
      ),
    );
  }

  Widget dropdownMenu(BuildContext context) {
    Pages pages = Provider.of<Pages>(context);

    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 0,
      alignment: Alignment.bottomRight,
      isDense: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        size: 15,
      ),
      elevation: 50,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 0,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        //This is called when the user selects an item.
        if (value == gpt4Sub[0]) {
          pages.defaultModelVersion = ModelVersion.gptv40;
        } else if (value == gpt4Sub[1]) {
          pages.defaultModelVersion = ModelVersion.gptv40Vision;
        } else {
          pages.defaultModelVersion = ModelVersion.gptv40Dall;
        }
        dropdownValue = value!;
      },
      items: gpt4Sub.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
