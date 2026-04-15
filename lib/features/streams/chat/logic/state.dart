enum ChatStatus { empty, loading, success, failure }

class ChatState {
  final ChatStatus status;
  final String? errorMessage;

  const ChatState({this.status = ChatStatus.empty, this.errorMessage});
}
