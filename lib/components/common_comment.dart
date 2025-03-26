import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/comment_model.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/service/cloudinary_service.dart';
import 'package:untitled/utils/content_converter.dart';

class CommonComment extends StatefulWidget {
  final Function() onGetComment;
  final Function()? onCreateComment;

  const CommonComment(
      {super.key, required this.onCreateComment, required this.onGetComment});

  @override
  State<CommonComment> createState() => _CommonCommentState();
}

class _CommonCommentState extends State<CommonComment> {
  final TextEditingController commentController = TextEditingController();
  bool isLoading = true;
  String avatarUrl = AppConstants.urlImageDefault;
  String profileName = '';
  List<CommentResponse> comments = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  final List<String> _uploadedImages = [];
  double sizeImageComment = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7 -
                  MediaQuery.of(context).viewInsets.bottom -
                  sizeImageComment,
              child: (isLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : (comments.isEmpty)
                      ? const Center(
                          child: Text('No comments available'),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentItem(comments[index]);
                          },
                        ),
            ),
            // const Spacer(),
            _buildCreateComment(),
          ],
        ),
      ),
    );
  }

  _buildCommentItem(CommentResponse comment) {
    final String profileImageUrl = comment.profileImageUrl ?? AppConstants.urlImageDefault;
    final convertedContent = convertContent(comment.content.text);
    final String text = convertedContent["text"];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.profileName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Text("now", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Text(text),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCreateComment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: "Write a comment...",
                  ),
                ),
              ),
              IconButton(
                onPressed: _pickImages,
                icon: const Icon(Icons.image),
              ),
              IconButton(
                onPressed: _onCreateComment,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          _buildSelectedImage(),
        ],
      ),
    );
  }

  // _buildImagePost(CommentResponse comment) {
  //   final convertedContent = convertContent(comment.content.text);
  //   final List<String> imageUrls = List<String>.from(convertedContent["imageUrls"]);
  //
  //   return SizedBox(
  //     height: MediaQuery.sizeOf(context).width / 3,
  //     child: Center(
  //       child: (imageUrls.length == 1)
  //           ? CachedNetworkImage(
  //               imageUrl: imageUrls[0],
  //               placeholder: (_, url) =>
  //                   const Center(child: CircularProgressIndicator()),
  //               errorWidget: (context, url, error) => const Icon(Icons.error),
  //             )
  //           : ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: imageUrls.length,
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.all(2.0),
  //                   child: SizedBox(
  //                     width: MediaQuery.sizeOf(context).width / 3,
  //                     child: CachedNetworkImage(
  //                       imageUrl: imageUrls[index],
  //                       placeholder: (_, url) =>
  //                           const Center(child: CircularProgressIndicator()),
  //                       errorWidget: (context, url, error) =>
  //                           const Icon(Icons.error),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //     ),
  //   );
  // }
  //
  // _buildVideoPost(CommentResponse comment) {
  //   final convertedContent = convertContent(comment.content.text);
  //   final List<String> videoUrls = List<String>.from(convertedContent["videoUrls"]);
  //
  //   return SizedBox(
  //     height: MediaQuery.sizeOf(context).width / 3,
  //     child: Center(
  //       child: (videoUrls.length == 1)
  //           ? BaseVideoPlayer(url: videoUrls[0])
  //           : ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: videoUrls.length,
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.all(2.0),
  //                   child: SizedBox(
  //                     width: MediaQuery.sizeOf(context).width / 3,
  //                     child:
  //                         BaseVideoPlayer(url: videoUrls[index]),
  //                   ),
  //                 );
  //               },
  //             ),
  //     ),
  //   );
  // }

  _buildSelectedImage() {
    return (_selectedImages.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100.0, // Adjust this value as needed
              width: double.infinity, // Adjust this value as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child:
                                Image.file(File(_selectedImages[index].path))),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.dangerous_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                              if (_selectedImages.isEmpty) {
                                sizeImageComment = 0;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    comments = await widget.onGetComment();
    avatarUrl = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    profileName = await LocalStorage.instance.userName ?? '';
    isLoading = false;
    setState(() {});
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) return;
    sizeImageComment = 100;
    setState(() {
      _selectedImages = images;
    });
  }

  _onCreateComment() async {
    isLoading = true;
    setState(() {});
    await widget.onCreateComment?.call();
    if (_selectedImages.isNotEmpty) {
      for (var element in _selectedImages) {
        final response =
            await CloudinaryService.instance.uploadImage(element.path);
        _uploadedImages.add(response);
      }
    }
    comments.add(CommentModel(
            profileName: profileName,
            profileImageUrl: avatarUrl,
            contentComment: ContentComment(
                text: commentController.text),
            createdAt: DateTime.now().toString())
        .toCommentResponse());

    commentController.clear();
    _selectedImages.clear();
    _uploadedImages.clear();
    sizeImageComment = 0;
    isLoading = false;
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
    setState(() {});
  }
}
