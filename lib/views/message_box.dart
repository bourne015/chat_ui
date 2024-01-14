import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../utils/constants.dart';
import '../utils/markdown_extentions.dart';
import '../utils/syntax_hightlighter.dart';

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
                    if (val["file"] != null) inputedImage(context),
                    messageContent(context)
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputedImage(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  //child: Container(
                  child: Image.network(val["file"]!.path),
                );
              });
        },
        onLongPressStart: (details) {
          _showDownloadMenu(context, details.globalPosition, val["file"]!.path);
        },
        child: Image.network(val["file"]!.path,
            height: 250, width: 200, fit: BoxFit.cover));
  }

  Widget messageContent(BuildContext context) {
    if (val["type"] == MsgType.image) {
      return contentImage(context);
    } else {
      return contentText(context);
    }
  }

  Widget contentText(BuildContext context) {
    return MarkdownBody(
      data: val['content'], //markdownTest,
      selectable: true,
      syntaxHighlighter: Highlighter(),
      //extensionSet: MarkdownExtensionSet.githubFlavored.value,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        <md.InlineSyntax>[
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
        ],
      ),
      styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
      styleSheet: MarkdownStyleSheet(
        //h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        // p: const TextStyle(fontSize: 17.0, color: AppColors.msgText),
        // a: const TextStyle(color: Colors.blue),
        code: const TextStyle(
          inherit: false,
          color: AppColors.msgText,
          fontWeight: FontWeight.bold,
        ),
      ),
      builders: {
        'code': CodeBlockBuilder(context, Highlighter()),
      },
    );
  }

  Widget contentImage(BuildContext context) {
    String imageBase64Str = val['content'];
    String imageB64Url = "data:image/png;base64,$imageBase64Str";
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    //child: Container(
                    child: Image.memory(base64Decode(
                        val['content'])) //Image.network(val['content']),
                    );
              });
        },
        onLongPressStart: (details) {
          _showDownloadMenu(context, details.globalPosition, imageB64Url);
        },
        child: Image.network(
          imageB64Url,
          height: 250,
          width: 200,
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
        ));
  }

  void _showDownloadMenu(
      BuildContext context, Offset position, String imageUrl) {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final RelativeRect positionRect = RelativeRect.fromLTRB(
      position.dx, // Left
      position.dy, // Top
      overlay!.size.width - position.dx, // Right
      overlay.size.height - position.dy, // Bottom
    );

    showMenu(
      context: context,
      position: positionRect,
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'download',
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text("download"),
          ),
        ),
        const PopupMenuItem(
          value: 'share',
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text("share"),
          ),
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue == 'download') {
        _downloadImage(imageUrl);
      }
    });
  }

  void _downloadImage(String imageUrl) {
    // create HTML的Anchor Element
    final html.AnchorElement anchor = html.AnchorElement(href: imageUrl);
    anchor.download = "gptsave"; // optional: download name
    anchor.click();
  }
}
