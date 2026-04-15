import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(title: Text('Item $index'));
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
