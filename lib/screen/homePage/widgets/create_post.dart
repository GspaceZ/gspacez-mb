import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/components/base_image_network.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/post_model_request.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/service/cloudinary_service.dart';
import 'package:untitled/service/squad_service.dart';
import 'package:untitled/utils/content_converter.dart';

import '../../../model/squad_access_response.dart';

class CreatePostDialog extends StatefulWidget {
  final Future<void> Function(PostModelRequest) onCreatePost;

  const CreatePostDialog({super.key, required this.onCreatePost});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog>
    with SingleTickerProviderStateMixin {
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
  final List<String> _hashTags = [];
  late TabController _tabController;
  final List<String> _urlImages = [];
  String previewImage = '';

  List<SquadAccessResponse> _squads = [];
  SquadAccessResponse? _selectedSquad;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    tagController.text = "#";
    _getUserInfo();
    _getSquads();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  Future<void> _getUserInfo() async {
    avatarUrl = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    userName = await LocalStorage.instance.userName ?? '';
    setState(() {});
  }

  Future<void> _getSquads() async {
    try {
      final squads = await SquadService.instance.getLastAccess();
      setState(() {
        _squads = squads;
        _selectedSquad = squads.isNotEmpty ? squads.first : null;
      });
    } catch (e) {
      debugPrint("Failed to fetch squads: $e");
      setState(() {});
    }
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 8),
          Text(userName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Title",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildTextField(titleController, "Your Title"),
                const SizedBox(height: 8),
                _buildSquadDropdown(),
                const SizedBox(height: 8),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.blueAccent,
                  tabs: const [Tab(text: "Write"), Tab(text: "Preview")],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    key: ValueKey(_tabController.index),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _buildTextField(
                            contentController, "What do you want to share?",
                            maxLines: 5),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: _buildPreview(),
                      ),
                    ],
                  ),
                ),
                _buildPreviewImage(),
                const SizedBox(height: 12),
                _getListOptions(),
                const SizedBox(height: 8),
                _buildShowTag(),
                _buildPrivacy(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton("Cancel", Colors.grey.shade200, Colors.black,
                        () => Navigator.of(context).pop()),
                    const SizedBox(width: 8),
                    _buildButton(
                        "Post", Colors.blue, Colors.white, _onClickPost),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSquadDropdown() {
    final recentSquads = _squads.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose your squad",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (recentSquads.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recent Squads",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentSquads.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final squad = recentSquads[index];
                    final isSelected = squad == _selectedSquad;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSquad = squad;
                        });
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.transparent,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            squad.avatarUrl ?? AppConstants.urlImageDefault,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        DropdownButtonFormField<SquadAccessResponse>(
          decoration:
              CusTomInputDecoration("Select Squad").getInputDecoration(),
          value: _selectedSquad,
          items: _squads.map((squad) {
            return DropdownMenuItem<SquadAccessResponse>(
              value: squad,
              child: Text(squad.name),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedSquad = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1.5, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildButton(
      String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildShowTag() {
    return Visibility(
      visible: isShowTag,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16)),
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
                        child: Text(tag,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
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

  Widget _buildPrivacy() {
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

  Widget _buildPreview() {
    final result = convertContent(contentController.text);
    final text = result['text'];

    return ListView(
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contentController.text.isEmpty &&
                  titleController.text.isEmpty)
                const Text("What do you want to share?",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              if (titleController.text.isNotEmpty)
                Text(titleController.text,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (text.isNotEmpty)
                Text(text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              if (_urlImages.isNotEmpty)
                Column(
                  children: _urlImages.map((url) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BaseImageNetwork(imageUrl: url, width: 150),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Preview Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        previewImage.isNotEmpty && previewImage.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: previewImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              )
            : GestureDetector(
                onTap: () => _pickFiles(isPreview: true),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'No image selected',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _getListOptions() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(onTap: _pickFiles, child: const Icon(Icons.image)),
          InkWell(
            onTap: () => setState(() => isShowTag = !isShowTag),
            child: Icon(Icons.tag,
                color: isShowTag ? Colors.deepOrange : Colors.black),
          ),
          InkWell(
            onTap: () => setState(() => isShowPrivacy = !isShowPrivacy),
            child: Icon(Icons.lock_outline,
                color: isShowPrivacy ? Colors.deepOrange : Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles({bool isPreview = false}) async {
    if (isPreview) {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;

      if (mounted) LoadingDialog.showLoadingDialog(context);

      try {
        final url = await CloudinaryService.instance.uploadImage(file.path);
        previewImage = url;
      } catch (e) {
        debugPrint('Failed to upload preview image: $e');
      }

      if (mounted) LoadingDialog.hideLoadingDialog();
      setState(() {});
    } else {
      final List<XFile> files = await _picker.pickMultiImage();
      if (files.isEmpty) return;

      if (mounted) LoadingDialog.showLoadingDialog(context);

      for (var file in files) {
        final url = await CloudinaryService.instance.uploadImage(file.path);
        _urlImages.add(url);
        contentController.text += "\n![Image]($url)\n";
      }

      if (mounted) LoadingDialog.hideLoadingDialog();
      setState(() {});
    }
  }

  Future<void> _onClickPost() async {
    final result = convertContent(contentController.text);
    final text = result['text'];

    final post = PostModelRequest(
      text: convertToMarkdown({
        "text": text,
        "imageUrls": _urlImages,
      }),
      privacy: _selectedPrivacy,
      previewImage: previewImage,
      squadTagName: _selectedSquad!.tagName,
      hashTags: _hashTags,
      title: titleController.text,
    );

    LoadingDialog.showLoadingDialog(context);
    await widget.onCreatePost(post);
    LoadingDialog.hideLoadingDialog();
    if (mounted) Navigator.of(context).pop();
  }
}
