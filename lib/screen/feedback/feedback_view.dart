import 'package:flutter/material.dart';
import '../../service/user_service.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;
  bool _isLoading = false;

  final GlobalKey _starKey = GlobalKey();
  final double _starSize = 40;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    setState(() => _isLoading = true);
    try {
      await UserService.instance.sendFeedback(_controller.text.trim(), _rating);
      setState(() => _submitted = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit feedback')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.feedback_outlined, color: Color(0xFF5A54F9), size: 36),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share Your Feedback',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A54F9),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Help us improve GspaceZ with your valuable insights',
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  if (_submitted)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            'Thank You For Your Feedback!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your input helps us make GspaceZ better for everyone.\n'
                                'We appreciate you taking the time to share your thoughts.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _submitted = false;
                                _controller.clear();
                                _rating = 0;
                              });
                            },
                            icon: const Icon(Icons.edit, color: Color(0xFF5A54F9)),
                            label: const Text(
                              'Submit Another Feedback',
                              style: TextStyle(color: Color(0xFF5A54F9), fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF4F4FF),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  else ...[
                    const Text(
                      "How would you rate your experience?",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onPanUpdate: (details) {
                        final box = _starKey.currentContext?.findRenderObject() as RenderBox?;
                        if (box != null) {
                          final local = box.globalToLocal(details.globalPosition);
                          final newRating = (local.dx / _starSize).clamp(1, 5).ceil();
                          setState(() => _rating = newRating);
                        }
                      },
                      onTapDown: (details) {
                        final box = _starKey.currentContext?.findRenderObject() as RenderBox?;
                        if (box != null) {
                          final local = box.globalToLocal(details.globalPosition);
                          final newRating = (local.dx / _starSize).clamp(1, 5).ceil();
                          setState(() => _rating = newRating);
                        }
                      },
                      child: Row(
                        key: _starKey,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < _rating ? const Color(0xFF5A54F9) : Colors.grey[300],
                            size: _starSize,
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Tell us more about your experience",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Share your thoughts, suggestions, or report issues...",
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _rating == 0 || _controller.text.trim().isEmpty || _isLoading
                            ? null
                            : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A54F9),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.send),
                        label: const Text("Submit Feedback"),
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
