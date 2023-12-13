import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

class Message {
  final String id;
  final int pageID;
  final String role;
  MsgType type;
  String content;
  XFile? file;
  String? fileBase64;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.pageID,
    required this.role,
    this.type = MsgType.text,
    required this.content,
    this.file,
    this.fileBase64,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    var res = <String, dynamic>{};
    if (file != null) {
      res = {
        'role': role,
        'content': [
          {'type': 'text', 'text': content},
          {
            'type': 'image_url',
            'image_url': {
              'url': "data:image/jpeg;base64,$fileBase64",
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
