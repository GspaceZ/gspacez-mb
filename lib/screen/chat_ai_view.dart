import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/chart_bubble.dart';
import 'package:untitled/view_model/chat_ai_view_model.dart';

class ChatAIView extends StatelessWidget {
  const ChatAIView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade900,
            Colors.purple.shade900,
            //  Colors.blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ChangeNotifierProvider(
        create: (BuildContext context) => ChatAIViewModel(),
        child: Consumer<ChatAIViewModel>(
          builder: (context, viewModel, child) {
            return (viewModel.isLoading)
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (viewModel.userController.message.isNotEmpty)
                        _buildIconNewChat(viewModel.newChat),
                      Expanded(
                        child: (viewModel.userController.message.isEmpty)
                            ? _buildEmptyChat()
                            : ListView.builder(
                                controller: viewModel.scrollController,
                                itemCount:
                                    viewModel.userController.message.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ChatBubble(
                                        message: viewModel
                                            .userController.message[index],
                                        name: viewModel.userController.name,
                                        avatar: viewModel.userController.avatar,
                                        color: viewModel.userController.color,
                                        isUser: true,
                                      ),
                                      if (index <
                                          viewModel
                                              .botController.message.length)
                                        ChatBubble(
                                          message: viewModel
                                              .botController.message[index],
                                          name: viewModel.botController.name,
                                          avatar:
                                              viewModel.botController.avatar,
                                          color: viewModel.botController.color,
                                          isUser: false,
                                        ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      _buildChatInputField(
                          viewModel.controller, viewModel.sendMessage)
                    ],
                  );
          },
        ),
      ),
    );
  }

  _buildEmptyChat() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Chip(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            label: const Text(
              "Welcome to Chat AI",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Chip(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            label: const Text(
              "Type something to start chat",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Chip(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            label: const Text(
              "Enjoy chatting",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  _buildIconNewChat(Function onPressed) {
    return IconButton(
      onPressed: () {
        onPressed();
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
        maximumSize: WidgetStateProperty.all(const Size(80, 80)),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      icon: const Icon(
        Icons.add_comment_sharp,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  _buildChatInputField(TextEditingController controller, Function sendMessage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          reverse: true,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w100),
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
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
