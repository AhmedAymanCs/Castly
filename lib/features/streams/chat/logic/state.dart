import 'package:castly/features/streams/chat/data/model/message_model.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { empty, loading, success, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageModel> messages;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.empty,
    this.messages = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    String? errorMessage,
  }) => ChatState(
    status: status ?? this.status,
    messages: messages ?? this.messages,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [status, messages, errorMessage];
}
