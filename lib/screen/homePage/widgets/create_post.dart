import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/post_model_request.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/utils/content_converter.dart';

class CreatePostDialog extends StatefulWidget {
  final Future<void> Function(PostModelRequest) onCreatePost;

  const CreatePostDialog({super.key, required this.onCreatePost});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> with SingleTickerProviderStateMixin {
  String avatarUrl = AppConstants.urlImageDefault;
  String userName = '';
  bool isShowTag = false;
  bool isShowPrivacy = false;
  final contentController = TextEditingController();
  final tagController = TextEditingController();
  final titleController = TextEditingController();
  final List<String> _privacyOptions = ['PUBLIC', 'PRIVATE'];
  String _selectedPrivacy = 'PUBLIC';
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final List<String> _hashTags = [];
  late TabController _tabController;

  Future<void> _pickFiles() async {
    final List<XFile> files = await _picker.pickMultiImage();
    setState(() {
      _selectedFiles.addAll(files);
      for (var file in files) {
        contentController.text += "\n![Image](${file.path})\n";
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
    tagController.dispose();
    titleController.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 8),
          Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildTextField(titleController, "Your Title"),
              const SizedBox(height: 8),
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.blueAccent,
                tabs: [
                  Tab(text: "Write"),
                  Tab(text: "Preview"),
                ],
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 200,
                child: TabBarView(
                  children: [
                    // Tab Write
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildTextField(contentController, "What do you want to share?", maxLines: 5),
                      ],
                    ),

                    // Tab Preview
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildTextField(contentController, "What do you want to share?", maxLines: 5),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _getListOptions(),
              const SizedBox(height: 8),
              _buildShowTag(),
              _buildPrivacy(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildButton("Cancel", Colors.grey.shade200, Colors.black, () => Navigator.of(context).pop()),
                  const SizedBox(width: 8),
                  _buildButton("Post", Colors.blue, Colors.white, () {
                    _onClickPost();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 1.5, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold))),
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
      width: MediaQuery.of(context).size.width * 0.8,
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
            child: Icon(Icons.tag,
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
      title: titleController.text,
    );

    LoadingDialog.showLoadingDialog(context);
    await widget.onCreatePost(post);
    LoadingDialog.hideLoadingDialog();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
