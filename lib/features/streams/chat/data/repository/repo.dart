import 'package:castly/features/streams/chat/data/data_source/data_source.dart';
import 'package:castly/features/streams/chat/data/model/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Unit> sendMessage(String message);
  Stream<MessageModel> receiveMessages();
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);
  @override
  Future<Unit> sendMessage(String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Stream<MessageModel> receiveMessages() {
    // TODO: implement receiveMessages
    throw UnimplementedError();
  }
}
