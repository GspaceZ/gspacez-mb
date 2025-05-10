import 'package:flutter/material.dart';
import '../../components/feedback_item.dart';
import '../../model/feedback_response.dart';
import '../../service/user_service.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final TextEditingController _feedbackController = TextEditingController();
  final GlobalKey _starRowKey = GlobalKey();
  final double _starIconSize = 40;

  int _currentRating = 0;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  bool _isLoadingAllFeedbacks = false;

  List<FeedbackResponse> _feedbackList = [];
  List<FeedbackResponse> _myFeedbackList = [];

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(() => setState(() {}));
    _fetchAllFeedbacks();
    _fetchMyFeedbacks();
  }

  Future<void> _fetchAllFeedbacks() async {
    setState(() => _isLoadingAllFeedbacks = true);
    try {
      final allFeedbacks = await UserService.instance.getAllFeedbacks();
      setState(() {
        _feedbackList = allFeedbacks;
      });
    } catch (_) {
      _showSnackBar('Failed to fetch all feedbacks');
    } finally {
      setState(() => _isLoadingAllFeedbacks = false);
    }
  }

  Future<void> _fetchMyFeedbacks() async {
    try {
      final myFeedbacks = await UserService.instance.getMyFeedbacks();
      setState(() {
        _myFeedbackList = myFeedbacks;
      });
    } catch (_) {
      _showSnackBar('Failed to fetch my feedbacks');
    } finally {
    }
  }

  Future<void> _submitFeedback() async {
    setState(() => _isSubmitting = true);
    try {
      await UserService.instance.sendFeedback(
        _feedbackController.text.trim(),
        _currentRating,
      );
      setState(() {
        _isSubmitted = true;
        _feedbackController.clear();
        _currentRating = 0;
      });

      await _fetchAllFeedbacks();
    } catch (_) {
      _showSnackBar('Failed to submit feedback');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteFeedback(String id) async {
    try {
      await UserService.instance.deleteMyFeedback(id);

      setState(() {
        _myFeedbackList.removeWhere((f) => f.id == id);
        _feedbackList.removeWhere((f) => f.id == id);
      });

      _showSnackBar('Feedback deleted successfully.');
    } catch (_) {
      _showSnackBar('Failed to delete feedback.');
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleRatingGesture(Offset globalPosition) {
    final box = _starRowKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final local = box.globalToLocal(globalPosition);
      final rating = (local.dx / _starIconSize).clamp(1, 5).ceil();
      setState(() => _currentRating = rating);
    }
  }

  Widget _buildStarRow() {
    return GestureDetector(
      onPanUpdate: (details) => _handleRatingGesture(details.globalPosition),
      onTapDown: (details) => _handleRatingGesture(details.globalPosition),
      child: Row(
        key: _starRowKey,
        children: List.generate(5, (i) {
          return Icon(
            Icons.star,
            size: _starIconSize,
            color: i < _currentRating ? const Color(0xFF5A54F9) : Colors.grey[300],
          );
        }),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("How would you rate your experience?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _buildStarRow(),
        const SizedBox(height: 24),
        const Text("Tell us more about your experience", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Share your thoughts, suggestions, or report issues...",
            fillColor: const Color(0xFFF9FAFB),
            filled: true,
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
            onPressed: (_currentRating == 0 || _feedbackController.text.trim().isEmpty || _isSubmitting)
                ? null
                : _submitFeedback,
            icon: _isSubmitting
                ? const SizedBox(
                height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send),
            label: const Text("Submit Feedback"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A54F9),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildThankYou() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Thank You For Your Feedback!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your input helps us make GspaceZ better for everyone.\nWe appreciate you taking the time to share your thoughts.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isSubmitted = false;
                _feedbackController.clear();
                _currentRating = 0;
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
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeedbackList() {
    if (_isLoadingAllFeedbacks) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_feedbackList.isEmpty) {
      return const Center(
        child: Text(
          "No feedback available yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _feedbackList.length,
      itemBuilder: (context, index) {
        final feedback = _feedbackList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FeedbackItem(
            feedback: feedback,
            isOwnFeedback: false,
            onDeleted: () => {},
          ),
        );
      },
    );
  }

  Widget _buildOwnFeedbackDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_outline, color: Color(0xFF5A54F9)),
                      SizedBox(width: 8),
                      Text(
                        'Your Feedbacks',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_myFeedbackList.isEmpty)
                const Text("You haven't submitted any feedback yet."),
              if (_myFeedbackList.isNotEmpty)
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _myFeedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = _myFeedbackList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FeedbackItem(
                          feedback: feedback,
                          isOwnFeedback: true,
                          onDeleted: () {
                            _deleteFeedback(feedback.id);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Feedback', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
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
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
                            Text('Share Your Feedback',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5A54F9))),
                            SizedBox(height: 4),
                            Text('Help us improve GspaceZ with your valuable insights',
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Center(
                    child: OutlinedButton(
                      onPressed: () async {
                        await _fetchMyFeedbacks();
                        showDialog(
                          context: context,
                          builder: (context) => _buildOwnFeedbackDialog(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF5A54F9)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      child: const Text(
                        "View your own feedbacks",
                        style: TextStyle(
                          color: Color(0xFF5A54F9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isSubmitted) _buildThankYou() else _buildFeedbackForm(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildFeedbackList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
