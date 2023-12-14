import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:html';

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
      String status = httpRequest.status.toString();
      String statusText = httpRequest.statusText ?? "Unknown error";
      String responseText = httpRequest.responseText ?? 'No response text';
      String errorMessage =
          "Error Status: $status, Status Text: $statusText, Response Text: $responseText";
      streamController.addError(errorMessage);
      debugPrint("event error: $errorMessage");
    });
    httpRequest.send(body);
    return streamController.stream;
  }
}
