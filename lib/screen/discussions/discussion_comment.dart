import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:untitled/model/discussion_comment_response.dart';
import '../../service/post_service.dart';

class DiscussionCommentItem extends StatefulWidget {
  final DiscussionCommentContent comment;

  const DiscussionCommentItem({
    super.key,
    required this.comment,
  });

  @override
  State<DiscussionCommentItem> createState() => _DiscussionCommentItemState();
}

class _DiscussionCommentItemState extends State<DiscussionCommentItem> {
  late DiscussionCommentContent comment;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
  }

  Future<void> handleUpvote() async {
    if (isLoading) return;

    setState(() => isLoading = true);
    try {
      final updatedComment = await PostService.instance.upvoteComment(comment.id);
      setState(() => comment = updatedComment);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upvote: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.avatarUrl),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.profileName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                MarkdownBody(
                  data: comment.content,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    GestureDetector(
                      onTap: isLoading ? null : handleUpvote,
                      child: Icon(
                        comment.isUpvote ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.totalUpvote}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4C6EF5),
                      ),
                    ),
                    const Spacer(),
                    if (comment.canBeEdited)
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
