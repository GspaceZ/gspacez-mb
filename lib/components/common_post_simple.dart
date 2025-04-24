import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/components/base_image_network.dart';
import 'package:untitled/components/common_comment.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/utils/format_time.dart';

import '../constants/appconstants.dart';
import '../screen/profile/profile_view.dart';
import '../service/post_service.dart';

class CommonPostSimple extends StatefulWidget {
  final PostModelResponse post;
  final VoidCallback? onLike;

  const CommonPostSimple({
    required this.post,
    super.key,
    this.onLike,
  });

  @override
  State<CommonPostSimple> createState() => _CommonPostState();
}

class _CommonPostState extends State<CommonPostSimple> {
  bool _isHide = false;
  bool _isBookmark = false;

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: (!_isHide)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfileView(
                                          profileId: widget.post.profileId),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.post.avatarUrl ??
                                        AppConstants.urlImageDefault,
                                    errorListener: (_) {
                                      Log.error(
                                          'Error loading image ${widget.post.avatarUrl}');
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.profileName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  formatTime(widget.post.createdAt),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w200),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _buildTitle(),
                  if (widget.post.hashTags != null) _buildHashTags(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: _buildImagePost(),
                    ),
                  ),
                  _buildRowIcon(widget.post)
                ],
              )
            : _buildHidePost(),
      ),
    );
  }

  _buildRowIcon(PostModelResponse post) {
    String postId = post.id;
    bool isLiked = post.liked;
    bool isDisliked = post.disliked;
    int totalLike = post.totalLike;
    int totalDislike = post.totalDislike;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              if (isLiked) return;
              try {
                final response =
                    await PostService.instance.reactPost(postId, 'LIKE');
                setState(() {
                  post.liked = true;
                  post.disliked = false;
                  post.totalLike = response.totalLikes;
                  post.totalDislike = response.totalDislikes;
                });
              } catch (e) {
                throw Exception("Failed to react post: $e");
              }
            },
            child: Row(
              children: [
                isLiked
                    ? const Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.blue,
                      )
                    : const Icon(
                        Icons.thumb_up_outlined,
                        color: Colors.black,
                      ),
                const SizedBox(width: 4),
                Text('$totalLike'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (isDisliked) return;
              try {
                final response =
                    await PostService.instance.reactPost(postId, 'DISLIKE');
                setState(() {
                  post.disliked = true;
                  post.liked = false;
                  post.totalLike = response.totalLikes;
                  post.totalDislike = response.totalDislikes;
                });
              } catch (e) {
                throw Exception("Failed to react post: $e");
              }
            },
            child: Row(
              children: [
                isDisliked
                    ? const Icon(
                        Icons.thumb_down_alt_outlined,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.thumb_down_outlined,
                        color: Colors.black,
                      ),
                const SizedBox(width: 4),
                Text('$totalDislike'),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _isBookmark = !_isBookmark;
              setState(() {});
            },
            icon: Icon(
              _isBookmark ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmark ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  _buildImagePost() {
    final imageUrl = widget.post.previewImage;
    return (imageUrl != null)
        ? GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, AppRoutes.postDetail, arguments: widget.post);
      },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).width / 1.5,
                  ),
                  child: Stack(
                    children: [
                      BaseImageNetwork(imageUrl: imageUrl),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "@${widget.post.squad.name.toUpperCase()}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
        )
        : const SizedBox.shrink();
  }

  _buildHidePost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8.0),
          child: Text(
            FlutterI18n.translate(context, "post.toggle.hide"),
          ),
        ),
        TextButton(
          onPressed: () {
            _isHide = false;
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  FlutterI18n.translate(context, "post.toggle.restore"),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHashTags() {
    final List<String> hashTags = widget.post.hashTags ?? [];
    const int maxVisible = 2;

    final List<Widget> chips = [];

    for (int i = 0; i < hashTags.length && i < maxVisible; i++) {
      chips.add(
        Chip(
          padding: const EdgeInsets.all(0.0),
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          label: Text("#${hashTags[i]}"),
        ),
      );
    }
    if (hashTags.length > maxVisible) {
      chips.add(
        Chip(
          padding: const EdgeInsets.all(0.0),
          backgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          label: Text("+${hashTags.length - maxVisible}"),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: chips,
      ),
    );
  }


  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.post.title ?? "",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
