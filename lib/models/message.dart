class Message {
  final String id;
  final int pageID;
  final String role;
  String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.pageID,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
    };
  }
}
