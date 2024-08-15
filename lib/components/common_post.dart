import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/components/image_row_view.dart';
import 'package:untitled/components/privacy_modal.dart';
import 'package:untitled/model/post_model.dart';
import 'package:video_player/video_player.dart';

class CommonPost extends StatefulWidget {
  final PostModel post;

  const CommonPost({required this.post, super.key});

  @override
  State<CommonPost> createState() => _CommonPostState();
}

class _CommonPostState extends State<CommonPost> {
  VideoPlayerController? _controller;
  bool _showFullText = false;
  bool _isLiked = false;
  bool _isHide = false;

  @override
  void initState() {
    super.initState();
    if (widget.post.urlVideo != null) {
      _controller =
      VideoPlayerController.networkUrl(Uri.parse(widget.post.urlVideo!))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
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
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.post.urlAvatar),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.author,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          const Text(
                            "Now",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w200),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                _buildPopupMenu(),
              ],
            ),
            _buildTextContent(),
            if (widget.post.urlVideo != null) _buildVideoPlayer(),
            if (widget.post.urlImages != null) _buildImagePost(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        _isLiked = !_isLiked;
                        setState(() {});
                      },
                      child: SvgPicture.asset("assets/svg/ic_like.svg",
                          color:
                          _isLiked ? Colors.orange : Colors.black)),
                  SvgPicture.asset("assets/svg/ic_comment.svg"),
                  SvgPicture.asset("assets/svg/ic_share.svg"),
                ],
              ),
            ),
          ],
        )
            : _buildHidePost(),
      ),
    );
  }

  _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const style = TextStyle(fontSize: 17);
          final textSpan = TextSpan(text: widget.post.content, style: style);
          final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout(maxWidth: constraints.maxWidth);

          final lines = textPainter.computeLineMetrics().length;

          TextStyle styleContent;
          double fontSize = 17;
          if (lines == 1 && widget.post.urlImages == null) {
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

          String displayText = widget.post.content;
          if (lines > 5 && !_showFullText) {
            final endPosition = textPainter
                .getPositionForOffset(
                Offset(constraints.maxWidth, fontSize * 5))
                .offset;
            displayText = '${widget.post.content.substring(0, endPosition)}...';
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
                InkWell(
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
    return SizedBox(
      height: MediaQuery.sizeOf(context).width,
      child: ImageCarousel(
        images: widget.post.urlImages!,
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
            child: InkWell(
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

  _buildPopupMenu() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          switch (value) {
            case "hide":
              _hidePost();
              break;
            case "privacy":
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return PrivacyModal();
                },
              );
              break;
            case "report":
              break;
          }
          setState(() {
            // _selectedOption = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: "hide",
              child: Center(
                  child: Text(FlutterI18n.translate(context, "post.hide"))),
            ),
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: "privacy",
              child: Center(
                  child: Text(FlutterI18n.translate(context, "post.privacy.privacy_btn"))),
            ),
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: "report",
              child: Center(
                  child: Text(FlutterI18n.translate(context, "post.report"))),
            ),
          ];
        },
        child: SvgPicture.asset(
          'assets/svg/ic_show_more.svg',
        ),
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

  void _hidePost() {
    // xử lý api hide post
    _isHide = true;
    setState(() {});
  }
}
