import 'package:castly/core/utils/typedef.dart';
import 'package:castly/features/streams/chat/data/data_source/data_source.dart';
import 'package:castly/features/streams/chat/data/model/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  ServerResponse<Unit> sendMessage(MessageModel message, String streamId);
  ServerResponse<Stream<MessageModel>> receiveMessages();
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);
  @override
  ServerResponse<Unit> sendMessage(
    MessageModel message,
    String streamId,
  ) async {
    try {
      await _dataSource.sendMessage(message, streamId);
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  ServerResponse<Stream<MessageModel>> receiveMessages() async {
    try {
      final stream = _dataSource.receiveMessages();
      return right(stream);
    } catch (e) {
      return left(e.toString());
    }
  }
}
