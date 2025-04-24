import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/components/common_comment.dart';
import 'package:untitled/components/image_row_view.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/utils/content_converter.dart';
import 'package:untitled/utils/format_time.dart';
import 'package:video_player/video_player.dart';

import '../constants/appconstants.dart';
import '../screen/profile/profile_view.dart';
import '../service/post_service.dart';

class CommonPost extends StatefulWidget {
  final PostModelResponse post;

  const CommonPost({
    required this.post,
    super.key,
  });

  @override
  State<CommonPost> createState() => _CommonPostState();
}

class _CommonPostState extends State<CommonPost> {
  bool _isMyPost = false;
  VideoPlayerController? _controller;
  bool _showFullText = false;
  bool _isHide = false;
  bool _isBookmark = false;
  bool _isShowComment = false;

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }

  @override
  void initState() {
    super.initState();
    _checkMyPost();
    final convertedContent = convertContent(widget.post.content.text);
    final List<String> videoUrls =
        List<String>.from(convertedContent["videoUrls"]);

    if (videoUrls.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrls.first),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  _checkMyPost() async {
    final userId = await LocalStorage.instance.userId ?? "";
    if (userId == widget.post.profileId) {
      _isMyPost = true;
    }
    setState(() {});
  }

  @override
  dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final convertedContent = convertContent(widget.post.content.text);
    final List<String> videoUrls =
        List<String>.from(convertedContent["videoUrls"]);
    final List<String> imageUrls =
        List<String>.from(convertedContent["imageUrls"]);

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
                      if(_isMyPost)
                        _buildEditPost(),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.post.content.text.isNotEmpty)
                            _buildTextContent(),
                          if (videoUrls.isNotEmpty) _buildVideoPlayer(),
                          if (imageUrls.isNotEmpty) _buildImagePost(),
                        ],
                      ),
                    ),
                  ),
                  _buildRowIcon(widget.post),
                  if (_isShowComment)
                    CommonComment(
                      postId: widget.post.id,
                      onGetComment: () async {
                        return await getComment(widget.post);
                      },
                    ),
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
              child: Row(children: [
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
              ])),
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
          GestureDetector(
            onTap: () {
              _isShowComment = !_isShowComment;
              setState(() {});
            },
            child: SvgPicture.asset(
              "assets/svg/ic_comment.svg",
              color: _isShowComment ? Colors.blue : Colors.black,
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

  _buildTextContent() {
    final convertedContent = convertContent(widget.post.content.text);
    final List<String> imageUrls =
        List<String>.from(convertedContent["imageUrls"]);
    final String text = convertedContent["text"];

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const style = TextStyle(fontSize: 17);
          final textSpan = TextSpan(text: text, style: style);
          final textPainter =
              TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout(maxWidth: constraints.maxWidth);

          final lines = textPainter.computeLineMetrics().length;

          TextStyle styleContent;
          double fontSize = 17;
          if (lines == 1 && imageUrls.isEmpty) {
            fontSize = 30;
            styleContent = const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold); // Font size for single line
          } else if (lines == 2 || lines == 3) {
            fontSize = 20;
            styleContent = const TextStyle(
                fontSize: 20); // Font size for two or three lines
          } else {
            fontSize = 16;
            styleContent = const TextStyle(
                fontSize: 16); // Font size for more than three lines
          }

          String displayText = text;
          if (lines > 5 && !_showFullText) {
            final endPosition = textPainter
                .getPositionForOffset(
                    Offset(constraints.maxWidth, fontSize * 5))
                .offset;
            displayText = '${text.substring(0, endPosition)}...';
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayText,
                style: styleContent,
                textAlign: TextAlign.start,
              ),
              if (lines > 5)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFullText = !_showFullText;
                    });
                  },
                  child: Text(
                    _showFullText
                        ? FlutterI18n.translate(context, "post.read_less")
                        : FlutterI18n.translate(context, "post.read_more"),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  _buildImagePost() {
    final convertedContent = convertContent(widget.post.content.text);
    final List<String> imageUrls =
        List<String>.from(convertedContent["imageUrls"]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).width / 1.5,
        ),
        child: ImageCarousel(
          images: imageUrls,
        ),
      ),
    );
  }

  _buildVideoPlayer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: GestureDetector(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                },
                child: VideoPlayer(_controller!)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _controller!.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(seconds: 1),
              child: IconButton(
                icon: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 50,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEditPost() {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 8.0),
     child: TextButton(
         onPressed: () {
           /// TODO: edit post
         },
         style: TextButton.styleFrom(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.blue,
                width: 0.5,
              ),
           ),
         ),
         child: const Text(
           "Edit post",
           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
         )
     ),
   );
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

  _buildHashTags() {
    final List<String> hashTags = widget.post.hashTags ?? [];
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: hashTags
            .map((e) => Chip(
                  backgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  label: Text("#$e"),
                ))
            .toList(),
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
