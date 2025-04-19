import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/model/notification_model.dart';

import '../constants/appconstants.dart';

class CommonNotification extends StatelessWidget {
  final NotificationModel notification;

  const CommonNotification({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final entity = notification.entity;
    final sender = entity.sender;

    String title;
    String? commentText;
    String? commentImage;

    if (notification.type == NotificationType.COMMENT) {
      title = "${sender.profileName} has commented on your post";

      commentText = entity.commentRequest?.content.text;

      if (entity.commentRequest?.content.imageUrls != null &&
          entity.commentRequest!.content.imageUrls!.isNotEmpty) {
        commentImage = entity.commentRequest!.content.imageUrls!.first;
      } else {
        final RegExp imageRegExp = RegExp(r'!\[.*?\]\((.*?)\)');
        final match = imageRegExp.firstMatch(commentText ?? "");
        if (match != null && match.groupCount >= 1) {
          commentImage = match.group(1);
        }
      }

      commentText = commentText?.replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), "").trim();

    } else if (notification.type == NotificationType.LIKE) {
      title = "${sender.profileName} has liked your post";
    } else if (notification.type == NotificationType.DISLIKE) {
      title = "${sender.profileName} has disliked your post";
    } else {
      title = "";
    }

    final avatarUrl = sender.profileImageUrl ?? "";

    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: sender.profileName ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${title.replaceFirst(sender.profileName ?? '', '')}',
                        ),
                      ],
                    ),
                  ),
                  if (commentText != null && commentText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      commentText,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (commentImage != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        commentImage,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(AppConstants.dateFormat).format(DateTime.parse(notification.createdAt)),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
