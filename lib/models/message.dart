import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

class Message {
  final String id;
  final int pageID;
  final String role;
  MsgType type;
  String content;
  XFile? file;
  List<int>? fileBytes;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.pageID,
    required this.role,
    this.type = MsgType.text,
    required this.content,
    this.file,
    this.fileBytes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    var res = <String, dynamic>{};
    if (file != null) {
      final html.File htmlFile = html.File(
        fileBytes!,
        file!.name,
        {'type': file!.mimeType},
      );
      String fileType = htmlFile.type;
      String fileBase64 = base64Encode(fileBytes!);
      res = {
        'role': role,
        'content': [
          {'type': 'text', 'text': content},
          {
            'type': 'image_url',
            'image_url': {
              'url': "data:$fileType;base64,$fileBase64",
            },
          },
        ]
      };
    } else {
      res = {
        'role': role,
        'content': content,
      };
    }
    return res;
  }
}
