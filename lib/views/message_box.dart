import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MessageBox extends StatelessWidget {
  final Map val;
  const MessageBox({super.key, required this.val});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
              val['role'] == MessageRole.user
                  ? Icons.person
                  : Icons.perm_identity,
              size: 32),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: val['role'] == MessageRole.user
                      ? AppColors.userMsgBox
                      : AppColors.aiMsgBox,
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
                  style: const TextStyle(
                      fontSize: 18.0, color: AppColors.msgText)),
            ),
          ),
        ],
      ),
    );
  }
}
