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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (val["file"] != null)
                      Image.network(val["file"]!.path,
                          height: 300, width: 300, fit: BoxFit.cover),
                    displayContent(context)
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayContent(BuildContext context) {
    if (val["type"] == MsgType.image) {
      return Image.network(
        val['content'],
        height: 512,
        width: 512,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.appBarBackground,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('image load error');
        },
      );
    } else {
      return SelectableText(val['content'],
          //overflow: TextOverflow.ellipsis,
          //showCursor: false,
          maxLines: null,
          style: const TextStyle(fontSize: 18.0, color: AppColors.msgText));
    }
  }
}
