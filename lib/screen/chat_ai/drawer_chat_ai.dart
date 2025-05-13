import 'package:flutter/material.dart';
import 'package:untitled/view_model/chat_ai_view_model.dart';

class DrawerChatAi extends StatelessWidget {
  final ChatAIViewModel viewModel;

  const DrawerChatAi({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Chat History",
                  style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    viewModel.newChat();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo.shade50,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.indigoAccent),
                      Text(
                        "New Chat",
                        style: TextStyle(color: Colors.indigoAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ...viewModel.historyChat.map((chat) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: Text(chat.userController.message[0],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                onTap: () {
                  viewModel.selectedChatHistory(chat.id);
                  Navigator.of(context).pop();
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
