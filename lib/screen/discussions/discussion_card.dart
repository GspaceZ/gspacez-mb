import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/router/app_router.dart';
import '../../model/discussion_response.dart';

class DiscussionCard extends StatelessWidget {
  final DiscussionResponse discussion;

  const DiscussionCard({super.key, required this.discussion});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMMM d, yyyy').format(discussion.createdAt);

    return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.detailDiscussion,
            arguments: discussion.id,
        );
      },
      borderRadius: BorderRadius.circular(12),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + badges
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        discussion.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (discussion.voteResponse != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'VOTE',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFFB8C00),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (!discussion.isOpen) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFECECEC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'CLOSED',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  discussion.content,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                if (discussion.hashTags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: discussion.hashTags
                        .map(
                          (e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEAFE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#$e',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5C6BC0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                const SizedBox(height: 12),
                // Avatar, name and date
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(discussion.avatarUrl),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        discussion.profileName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}
