import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/discussion_form_request.dart';
import '../../service/post_service.dart';
import 'discussion_detail.dart';

class DiscussionForm extends StatefulWidget {
  final String? id;

  const DiscussionForm({super.key, this.id});

  @override
  State<DiscussionForm> createState() => _DiscussionFormState();
}

class _DiscussionFormState extends State<DiscussionForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _voteTitleController = TextEditingController();
  final _tagController = TextEditingController();

  final List<TextEditingController> _optionControllers = [];
  final List<String> _tags = [];

  bool _voteEnabled = false;
  late TabController _tabController;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.id != null) {
      _isEditMode = true;
      _loadExistingDiscussion(widget.id!); // Load existing discussion if ID is provided
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _voteTitleController.dispose();
    _tagController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadExistingDiscussion(String id) async {
    try {
      // Fetch the existing discussion details using your API
      final discussion = await PostService.instance.getDetailDiscussion(id);

      // Map the response data to the form fields
      setState(() {
        _titleController.text = discussion.title;
        _contentController.text = discussion.content;
        _tags.addAll(discussion.hashTags);

        // If there is a vote request, load the vote data
        if (discussion.voteResponse != null) {
          _voteEnabled = true;
          _voteTitleController.text = discussion.voteResponse!.title;
          _optionControllers.clear();
          _optionControllers.addAll(
            discussion.voteResponse!.options.map((option) => TextEditingController(text: option.value)),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load discussion: ${e.toString()}")),
      );
    }
  }

  void _addOption() {
    setState(() => _optionControllers.add(TextEditingController()));
  }

  void _removeOption(int index) {
    setState(() => _optionControllers.removeAt(index));
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final markdown = "![default-avatar](${picked.path})";
      setState(() {
        _contentController.text += "\n$markdown";
      });
    }
  }

  void _addTag(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !_tags.contains(trimmed)) {
      setState(() => _tags.add(trimmed));
    }
    _tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  Future<void> _submitDiscussion() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final voteOptions = _optionControllers.map((c) => c.text.trim()).where((e) => e.isNotEmpty).toList();
      final voteRequest = _voteEnabled
          ? VoteRequest(
        title: _voteTitleController.text.trim(),
        options: voteOptions,
      )
          : null;

      final request = DiscussionFormRequest(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        hashTags: _tags,
        voteRequest: voteRequest,
      );

      if (_isEditMode) {
        final response = await PostService.instance.updateDiscussion(request, widget.id!);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Discussion updated successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DiscussionDetail(id: response.id),
          ),
        );
      } else {
        // Create a new discussion
        final response = await PostService.instance.createDiscussion(request);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Discussion created successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DiscussionDetail(id: response.id),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to process discussion: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          _isEditMode ? 'Edit Discussion' : 'Create a Discussion',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Discussion Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                validator: (val) => val == null || val.trim().isEmpty ? "Title is required" : null,
                decoration: const InputDecoration(
                  hintText: "Your title",
                  prefixIcon: Icon(Icons.chat_outlined),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black45,
                      indicatorColor: Colors.blueAccent,
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 6),
                              Text("Write"),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.remove_red_eye_outlined, size: 18),
                              SizedBox(width: 6),
                              Text("Preview"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 180,
                      padding: const EdgeInsets.all(12),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          TextFormField(
                            controller: _contentController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "What do you want to share?",
                            ),
                          ),
                          Markdown(
                            data: _contentController.text,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: const Row(
                                children: [
                                  Icon(Icons.cloud_upload_outlined, size: 18, color: Colors.black54),
                                  SizedBox(width: 4),
                                  Text("Upload media", style: TextStyle(color: Colors.black87)),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.black26,
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    ..._tags.map((tag) => Chip(
                                      label: Text(tag, style: const TextStyle(fontSize: 14)),
                                      deleteIcon: const Icon(Icons.close, size: 16),
                                      onDeleted: () => _removeTag(tag),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    )),
                                    if (_tags.isEmpty)
                                      SizedBox(
                                        width: 140,
                                        child: TextField(
                                          controller: _tagController,
                                          onSubmitted: _addTag,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            hintText: "Write your tags",
                                            isDense: true,
                                            prefixText: "# ",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 28,
                    width: 50,
                    child: Switch(
                      value: _voteEnabled,
                      onChanged: (val) => setState(() => _voteEnabled = val),
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF3B82F6),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFDEE2E6),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Create a vote request",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
              if (_voteEnabled) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _voteTitleController,
                  decoration: const InputDecoration(
                    hintText: "Your vote request title",
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text("Options", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ..._optionControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Option",
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _removeOption(index),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addOption,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Option"),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitDiscussion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF228BE6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text(
                    "Submit your new discussion",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
