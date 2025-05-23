String formatTime(DateTime createAt) {
  final now = DateTime.now();
  final difference = now.difference(createAt);
  if (difference.inDays > 365) {
    return "${difference.inDays ~/ 365} years ago";
  } else if (difference.inDays > 30) {
    return "${difference.inDays ~/ 30} months ago";
  } else if (difference.inDays > 0) {
    return "${difference.inDays} days ago";
  } else if (difference.inHours > 0) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0) {
    return "${difference.inMinutes} minutes ago";
  } else {
    return "Now";
  }
}
