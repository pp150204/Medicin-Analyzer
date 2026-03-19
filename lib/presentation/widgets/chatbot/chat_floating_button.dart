import 'package:flutter/material.dart';
import 'chat_window.dart';

class ChatFloatingButton extends StatelessWidget {
  const ChatFloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 500,
                width: 400,
                child: const ChatWindow(),
              ),
            );
          },
        );
      },
      label: const Text('Ask AI'),
      icon: const Icon(Icons.chat_bubble_outline),
    );
  }
}
