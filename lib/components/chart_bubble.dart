import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String name;
  final String avatar;
  final Color color;
  final bool isUser;
  final Function(String) onEditSubmit;
  final Function() onRegenerate;
  final int index;

  const ChatBubble({
    super.key,
    required this.message,
    required this.name,
    required this.avatar,
    required this.color,
    required this.isUser,
    required this.onEditSubmit,
    required this.onRegenerate,
    required this.index,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onEditSubmit(_controller.text);
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment:
        widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUser)
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
          if (!widget.isUser) const SizedBox(width: 8),

          if (widget.isUser && !isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 4),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                  widget.isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight:
                  widget.isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: widget.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isEditing)
                    Column(
                      children: [
                        TextField(
                          controller: _controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFced4da),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFced4da),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                backgroundColor: const Color(0xFFFFEEF0),
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = false;
                                });
                              },
                              child: const Text("Cancel"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4263eb),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _handleSave,
                              child: const Text("Send"),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (widget.isUser) const SizedBox(width: 8),
          if (widget.isUser)
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),

          if (!widget.isUser && !isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 4),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                  color: Colors.black54,
                ),
                onPressed: widget.onRegenerate,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}
