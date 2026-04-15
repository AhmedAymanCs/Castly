import 'dart:async';

import 'package:castly/features/streams/chat/data/model/message_model.dart';
import 'package:castly/features/streams/chat/data/repository/repo.dart';
import 'package:castly/features/streams/chat/logic/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  ChatCubit(this._repository) : super(const ChatState());

  Future<void> sendMessage(String text, String streamId) async {
    final MessageModel message = MessageModel(
      message: text,
      sender: 'Ahmed',
      timestamp: DateTime.now(),
    );
    final result = await _repository.sendMessage(message, streamId);
    result.fold(
      (error) =>
          emit(state.copyWith(status: ChatStatus.failure, errorMessage: error)),
      (_) => null,
    );
  }

  void receiveMessages(String streamId) {
    emit(state.copyWith(status: ChatStatus.loading));
    _repository.receiveMessages(streamId).then((result) {
      result.fold(
        (error) => emit(
          state.copyWith(status: ChatStatus.failure, errorMessage: error),
        ),
        (stream) {
          _messagesSubscription = stream.listen((messages) {
            emit(
              state.copyWith(status: ChatStatus.success, messages: messages),
            );
          });
        },
      );
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
