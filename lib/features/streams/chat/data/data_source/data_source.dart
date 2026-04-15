import 'package:castly/features/streams/chat/data/model/message_model.dart';

abstract class ChatDataSource {
  Future<void> sendMessage(String message);
  Stream<MessageModel> receiveMessages();
}

class ChatDataSourceImpl implements ChatDataSource {
  @override
  Future<void> sendMessage(String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Stream<MessageModel> receiveMessages() {
    // TODO: implement receiveMessages
    throw UnimplementedError();
  }
}
