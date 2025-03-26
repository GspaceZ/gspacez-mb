import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/post_model_request.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import '../../../utils/content_converter.dart';

class CreatePostDialog extends StatefulWidget {
  final Future<void> Function(PostModelRequest) onCreatePost;

  const CreatePostDialog({super.key, required this.onCreatePost});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  String avatarUrl = AppConstants.urlImageDefault;
  String userName = '';
  bool isShowTag = false;
  bool isShowPrivacy = false;
  final contentController = TextEditingController();
  final tagController = TextEditingController();
  String _title = '';
  final List<String> _privacyOptions = ['PUBLIC', 'PRIVATE'];
  String _selectedPrivacy = 'PUBLIC';
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final List<String> _hashTags = [];

  Future<void> _pickFiles() async {
    final List<XFile> files = await _picker.pickMultiImage();
    setState(() {
      _selectedFiles.addAll(files);
    });
  }

  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
    tagController.dispose();
  }

  @override
  void initState() {
    super.initState();
    tagController.text = "#";
    _getUserInfo();
  }

  _getUserInfo() async {
    avatarUrl = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    userName = await LocalStorage.instance.userName ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 8),
          Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: contentController,
                  decoration:
                      CusTomInputDecoration(null).getInputDecoration().copyWith(
                            hintText: FlutterI18n.translate(
                              context,
                              'post.modal.placeholder',
                            ),
                          ),
                  maxLines: 5,
                ),
              ),
              if (_selectedFiles.isNotEmpty)
                SizedBox(
                  height: 200.0, // Adjust this value as needed
                  width: double.infinity, // Adjust this value as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _selectedFiles.length,
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
                                child: Image.file(
                                    File(_selectedFiles[index].path))),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.dangerous_outlined),
                              onPressed: () {
                                setState(() {
                                  _selectedFiles.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'post.modal.cancel'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => _onClickPost(),
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'post.modal.post'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _getListOptions(),
              const SizedBox(height: 8),
              _buildShowTag(),
              _buildPrivacy(),
            ],
          ),
        ),
      ),
    );
  }

  _buildShowTag() {
    return Visibility(
      visible: isShowTag,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Row(
                children: _hashTags.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tag,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: TextField(
                  controller: tagController,
                  decoration: InputDecoration(
                    hintText: FlutterI18n.translate(context, 'post.modal.tags'),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.contains(' ') && value.length > 1) {
                      setState(() {
                        _hashTags.add(value);
                        tagController.clear();
                        tagController.text = "#";
                      });
                    }
                    if (value.isEmpty) {
                      tagController.text = "#";
                      if (_hashTags.isNotEmpty) {
                        _hashTags.removeLast();
                      }
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildPrivacy() {
    return Visibility(
      visible: isShowPrivacy,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: CusTomInputDecoration(
                  FlutterI18n.translate(context, 'post.modal.privacy'))
              .getInputDecoration(),
          value: _selectedPrivacy,
          items: _privacyOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPrivacy = newValue!;
            });
          },
        ),
      ),
    );
  }

  _getListOptions() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: _pickFiles,
            child: const Icon(Icons.image),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isShowTag = !isShowTag;
              });
            },
            child: Icon(Icons.more_outlined,
                color: isShowTag ? Colors.deepOrange : Colors.black),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isShowPrivacy = !isShowPrivacy;
              });
            },
            child: Icon(Icons.lock_outline,
                color: isShowPrivacy ? Colors.deepOrange : Colors.black),
          ),
        ],
      ),
    );
  }

  _onClickPost() async {
    List<String> imageUrls = _selectedFiles.map((file) => file.path).toList();

    final post = PostModelRequest(
      text: convertToMarkdown({
        "text": contentController.text,
        "imageUrls": imageUrls,
      }),
      privacy: _selectedPrivacy,
      hashTags: _hashTags,
      title: _title,
    );

    LoadingDialog.showLoadingDialog(context);
    await widget.onCreatePost(post);
    LoadingDialog.hideLoadingDialog();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
