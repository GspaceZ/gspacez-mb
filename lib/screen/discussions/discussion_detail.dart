import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/local/local_storage.dart';
import '../../model/discussion_comment_response.dart';
import '../../model/discussion_response.dart';
import '../../router/app_router.dart';
import '../../service/post_service.dart';
import 'discussion_comment.dart';

class DiscussionDetail extends StatefulWidget {
  final String id;
  const DiscussionDetail({super.key, required this.id});

  @override
  State<DiscussionDetail> createState() => _DiscussionDetailState();
}

class _DiscussionDetailState extends State<DiscussionDetail> {
  late Future<DiscussionResponse> _future;
  String profileId = '';
  final TextEditingController _contentController = TextEditingController();
  late List<DiscussionCommentContent> comments;
  int page = 0;
  int size = 10;
  bool isDisable = false;

  @override
  void initState() {
    super.initState();
    _future = PostService.instance.getDetailDiscussion(widget.id);
    fetchComments();
    _init();

    _contentController.addListener(() {
      setState(() {
        isDisable = _contentController.text.trim().isNotEmpty;
      });
    });
  }

  void _init() async {
    final id = await LocalStorage.instance.userId ?? "";
    if (mounted) {
      setState(() {
        profileId = id;
      });
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await PostService.instance.getCommentDiscussion(widget.id, page, size);
      setState(() {
        comments = response.content;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
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

  void _votePoll(String discussionId, String optionId) async {
    try {
      final voteResponse = await PostService.instance.votePoll(discussionId, optionId);

      setState(() {
        _future = _future.then(
              (discussionResponse) => discussionResponse.copyWith(voteResponse: voteResponse),
        );
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to vote: $e')),
        );
      }
    }
  }

  Future<void> submitComment() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    try {
      await PostService.instance.postComment(widget.id, content);
      _contentController.clear();
      FocusScope.of(context).unfocus();
      await fetchComments();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment posted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text('Detail Discussion', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DiscussionResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || profileId.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error: \${snapshot.error}", style: TextStyle(color: Colors.black87)),
            );
          }

          final discussion = snapshot.data!;
          final isOwner = discussion.profileId == profileId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDiscussionCard(context, discussion, isOwner),
                const SizedBox(height: 16),
                if (discussion.voteResponse != null)
                  _buildVoteCard(discussion),
                const SizedBox(height: 16),
                _buildCommentsCard(context, discussion.isOpen),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscussionCard(BuildContext context, DiscussionResponse discussion, bool isOwner) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(discussion, isOwner),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    discussion.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                if (discussion.voteResponse != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(253, 126, 20, 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text("VOTE", style: TextStyle(color: Color(0xFFFD7E14), fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(width: 8),
                if (!discussion.isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(134, 142, 150, 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text("CLOSED", style: TextStyle(color: Color(0xFF868E96), fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              data: discussion.content,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            if (discussion.hashTags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: discussion.hashTags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(76, 110, 245, 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "#$tag",
                      style: const TextStyle(
                        color: Color(0xFF4C6EF5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteCard(DiscussionResponse discussion) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildPoll(discussion),
      ),
    );
  }

  Widget _buildCommentsCard(BuildContext context, bool isOpen) {
    final card = Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),

          if (isOpen) ...[
            const TabBar(
              labelColor: Color(0xFF4C6EF5),
              unselectedLabelColor: Colors.black54,
              indicatorColor: Color(0xFF4C6EF5),
              tabs: [
                Tab(text: 'Write'),
                Tab(text: 'Preview'),
              ],
            ),
            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              child: TabBarView(
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
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18, color: Color(0xFFADB5BD)),
                  label: const Text("Upload media", style: TextStyle(color: Color(0xFFADB5BD), fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 12, top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: isDisable ? submitComment : null,
                  icon: Icon(Icons.send, size: 16, color: _contentController.text.isNotEmpty
                      ? Colors.white
                      : const Color(0xFFADB5BD)),
                  label: Text(
                    'Post comment',
                    style: TextStyle(
                      color: isDisable
                          ? Colors.white
                          : const Color(0xFFADB5BD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C6EF5),
                    disabledBackgroundColor: const Color(0xFFF1F3F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (comments.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return DiscussionCommentItem(comment: comment);
              },
            ),
          ],
          if (comments.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("No comments yet. Be the first to comment!", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return DefaultTabController(
      length: 2,
      child: card,
    );
  }

  Widget _buildHeader(DiscussionResponse discussion, bool isOwner) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(discussion.avatarUrl)),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      discussion.profileName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, yyyy, h:mm:ss a').format(discussion.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        try {
                          final updatedDiscussion = await PostService.instance.toggleDiscussion(
                            discussion.id,
                            !discussion.isOpen,
                          );
                          if (mounted) {
                            setState(() {
                              _future = Future.value(updatedDiscussion);
                            });
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to toggle status: $e')),
                            );
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: discussion.isOpen ? Colors.red : const Color(0xFF40c057),
                        side: BorderSide(color: discussion.isOpen ? Colors.red : const Color(0xFF40c057)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.all(8),
                      ),
                      child: Icon(
                        discussion.isOpen ? Icons.close : Icons.check,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.updateDiscussion, arguments: discussion.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.all(8),
                      ),
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPoll(DiscussionResponse discussion) {
    final VoteResponse vote = discussion.voteResponse!;
    final String? selectedOptionId = vote.selectedOptionId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          vote.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...vote.options.map((opt) {
          final percent = opt.percentage.clamp(0, 100);
          final isSelected = opt.id == selectedOptionId;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          opt.value ?? "",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(76, 110, 245, 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${percent.toStringAsFixed(0)} %",
                            style: const TextStyle(
                              color: Color(0xFF4C6EF5),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: discussion.isOpen && !isSelected
                          ? () => _votePoll(discussion.id, opt.id)
                          : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(76, 110, 245, 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.all(8),
                      ),
                      child: Text(
                        "Vote",
                        style: TextStyle(
                          color: discussion.isOpen && !isSelected
                              ? const Color(0xFF4C6EF5)
                              : const Color(0xFFADB5BD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percent / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF868E96),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
