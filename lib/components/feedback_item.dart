import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/constants/appconstants.dart';
import '../model/feedback_response.dart';

class FeedbackItem extends StatelessWidget {
  final FeedbackResponse feedback;
  final bool isOwnFeedback;
  final VoidCallback? onDeleted;

  const FeedbackItem({
    super.key,
    required this.feedback,
    required this.isOwnFeedback,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy, h:mm a').format(feedback.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwnFeedback)
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(AppConstants.urlImageDefault),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Spacer(),
              ],
            )
          else
            Text(
              'Feedback at $formattedDate',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final filled = index < feedback.rate;
              return Icon(
                Icons.star,
                color: filled ? Colors.orange : Colors.grey[300],
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(feedback.content, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          if (isOwnFeedback)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onDeleted,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Delete this feedback',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
