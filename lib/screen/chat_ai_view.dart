import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/chart_bubble.dart';
import 'package:untitled/view_model/chat_ai_view_model.dart';

class ChatAIView extends StatelessWidget {
  const ChatAIView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Chat with AI",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.rocket_launch,
              color: Colors.blue,
              size: 20,
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChatAIViewModel(),
        child: Consumer<ChatAIViewModel>(
          builder: (context, viewModel, child) {
            return (viewModel.isLoading)
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFc7d2fe)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFc7d2fe).withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: (viewModel.userController.message.isEmpty)
                        ? _buildEmptyChat()
                        : ListView.builder(
                      controller: viewModel.scrollController,
                      itemCount: viewModel.userController.message.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ChatBubble(
                              message: viewModel.userController.message[index],
                              name: viewModel.userController.name,
                              avatar: viewModel.userController.avatar,
                              color: viewModel.userController.color,
                              isUser: true,
                            ),
                            if (index < viewModel.botController.message.length)
                              ChatBubble(
                                message: viewModel.botController.message[index],
                                name: viewModel.botController.name,
                                avatar: viewModel.botController.avatar,
                                color: viewModel.botController.color,
                                isUser: false,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                _buildChatInputField(viewModel.controller, viewModel.sendMessage),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_outlined),
          SizedBox(height: 10),
          Text(
            "Enter prompt to start a conversation",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 10),
          Text(
            "Ask me anything about technology",
            style: TextStyle(color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInputField(TextEditingController controller, Function sendMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Ask AI something...",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    sendMessage();
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Color(0xFF3f51b5)),
              onPressed: () {
                sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
