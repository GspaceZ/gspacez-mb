import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/model/post_model.dart';
import 'package:untitled/provider/user_info_provider.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';

class CreatePostDialog extends StatefulWidget {
  final Future<void> Function(PostModel) onCreatePost;

  const CreatePostDialog({super.key, required this.onCreatePost});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  bool isShowLocation = false;
  bool isShowFeeling = false;
  bool isShowTag = false;
  bool isShowPrivacy = false;
  final contentController = TextEditingController();
  final locationController = TextEditingController();
  final feelingController = TextEditingController();
  final tagController = TextEditingController();
  final List<String> _privacyOptions = ['Public', 'Private', 'Friend'];
  String _selectedPrivacy = 'Public';
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final List<String> _tags = [];

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
    locationController.dispose();
    feelingController.dispose();
    tagController.dispose();
  }

  @override
  void initState() {
    super.initState();
    tagController.text = "#";
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserInfoProvider>();
    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.urlAvatar),
          ),
          const SizedBox(width: 8),
          Text(
            user.name,
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
              _buildShowLocation(),
              _buildShowFeeding(),
              _buildShowTag(),
              _buildPrivacy(),
            ],
          ),
        ),
      ),
    );
  }

  _buildShowLocation() {
    return Visibility(
      visible: isShowLocation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          controller: locationController,
          decoration: CusTomInputDecoration(
                  FlutterI18n.translate(context, 'post.modal.location'))
              .getInputDecoration(),
        ),
      ),
    );
  }

  _buildShowFeeding() {
    return Visibility(
      visible: isShowFeeling,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          controller: feelingController,
          decoration: CusTomInputDecoration(
                  FlutterI18n.translate(context, 'post.modal.feeling'))
              .getInputDecoration(),
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
                children: _tags.map((tag) {
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
                        _tags.add(value);
                        tagController.clear();
                        tagController.text = "#";
                      });
                    }
                    if (value.isEmpty) {
                      tagController.text = "#";
                      if (_tags.isNotEmpty) {
                        _tags.removeLast();
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
                isShowLocation = !isShowLocation;
              });
            },
            child: Icon(Icons.location_on_outlined,
                color: isShowLocation ? Colors.deepOrange : Colors.black),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isShowFeeling = !isShowFeeling;
              });
            },
            child: Icon(Icons.emoji_emotions_outlined,
                color: isShowFeeling ? Colors.deepOrange : Colors.black),
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
    final post = PostModel(
        author: 'Mạc Bùi',
        content: contentController.text,
        urlAvatar:
            'https://res.cloudinary.com/dszkt92jr/image/upload/v1721463934/fgcnetakyb8nibeqr9do.png');
    LoadingDialog.showLoadingDialog(context);
    await widget.onCreatePost(post);
    LoadingDialog.hideLoadingDialog();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
