class MessageModel {
  final String message;
  final String sender;
  final DateTime timestamp;

  MessageModel({
    required this.message,
    required this.sender,
    required this.timestamp,
  });
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      sender: map['sender'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
