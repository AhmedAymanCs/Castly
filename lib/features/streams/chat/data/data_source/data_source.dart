import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/features/streams/chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatDataSource {
  Future<void> sendMessage(MessageModel message, String straemId);
  Stream<MessageModel> receiveMessages();
}

class ChatDataSourceImpl implements ChatDataSource {
  final FirebaseFirestore _firestore;

  ChatDataSourceImpl(this._firestore);
  @override
  Future<void> sendMessage(MessageModel message, String straemId) async {
    _firestore
        .collection(AppConstants.streamsCollectionName)
        .doc(straemId)
        .collection(AppConstants.messagesCollectionName)
        .add(message.toMap());
  }

  @override
  Stream<MessageModel> receiveMessages() {
    // TODO: implement receiveMessages
    throw UnimplementedError();
  }
}
