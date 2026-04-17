import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:castly/core/models/user_model.dart';
import 'package:castly/core/widgets/cutom_form_field.dart';
import 'package:castly/features/streams/chat/logic/cubit.dart';
import 'package:castly/features/streams/chat/logic/state.dart';
import 'package:castly/features/streams/chat/presentation/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  final StreamModel stream;
  final UserModel user;
  const ChatView({super.key, required this.stream, required this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        _scrollToBottom();
      },
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [ColorManager.gray900, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: state.messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    return MessageView(
                      message: state.messages[index].message,
                      sender: state.messages[index].sender,
                      avatarUrl: state.messages[index].avatarUrl,
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      hint: StringManager.writeMessage,
                      controller: _messageController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      cubit
                          .sendMessage(
                            text: _messageController.text,
                            streamId: widget.stream.id,
                            user: widget.user,
                          )
                          .then((_) {
                            _messageController.clear();
                          });
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
