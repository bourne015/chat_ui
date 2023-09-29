import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:html';

import 'package:mychat/constants.dart';

bool isDisplayDesktop(BuildContext context) =>
    !isDisplayFoldable(context) &&
    getWindowType(context) >= AdaptiveWindowType.medium;

bool isDisplayFoldable(BuildContext context) {
  final hinge = MediaQuery.of(context).hinge;
  if (hinge == null) {
    return false;
  } else {
    // Vertical
    return hinge.bounds.size.aspectRatio < 1;
  }
}

class MessageBox extends StatelessWidget {
  //final String role;
  //final String content
  final Map val;

  const MessageBox({super.key, required this.val});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(val['role'] == "user" ? Icons.person : Icons.perm_identity,
              size: 32),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: val['role'] == "user"
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

class ChatSSE {
  Stream<String> connect(String path, String method,
      {Map<String, dynamic>? headers, String? body}) {
    int progress = 0;
    //const asciiEncoder = AsciiEncoder();
    final httpRequest = HttpRequest();
    final streamController = StreamController<String>();
    httpRequest.open(method, path);
    headers?.forEach((key, value) {
      httpRequest.setRequestHeader(key, value);
    });
    //httpRequest.onProgress.listen((event) {
    httpRequest.addEventListener('progress', (event) {
      final data = httpRequest.responseText!.substring(progress);

      var lines = data.split("\r\n\r");
      for (var line in lines) {
        line = line.trimLeft();
        for (var vline in line.split('\n')) {
          if (vline.startsWith("data:")) {
            vline = vline.substring(5).replaceFirst(' ', '');
            streamController.add(vline);
          }
        }
      }

      progress += data.length;
    });
    httpRequest.addEventListener('loadstart', (event) {
      final data = httpRequest.responseText!.substring(0);
      debugPrint("event start:$data");
    });
    httpRequest.addEventListener('load', (event) {
      debugPrint("event load");
    });
    httpRequest.addEventListener('loadend', (event) {
      httpRequest.abort();
      if (!streamController.isClosed) {
        streamController.close();
      }
      debugPrint("event end");
    });
    httpRequest.addEventListener('error', (event) {
      streamController.addError(
        httpRequest.responseText ?? httpRequest.status ?? 'err',
      );
      debugPrint("event error");
    });
    httpRequest.send(body);
    return streamController.stream;
  }
}
