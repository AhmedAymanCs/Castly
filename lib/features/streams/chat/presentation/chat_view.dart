import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/widgets/cutom_form_field.dart';
import 'package:castly/features/streams/chat/logic/cubit.dart';
import 'package:castly/features/streams/chat/logic/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  final String streamId;
  const ChatView({super.key, required this.streamId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  return Text(
                    state.messages[index].message,
                    style: const TextStyle(color: Colors.white),
                  );
                },
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
                          .sendMessage(_messageController.text, widget.streamId)
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
}
