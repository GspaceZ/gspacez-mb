import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/constants/appconstants.dart';
import '../../components/common_post.dart';
import '../../model/squad_response.dart';
import '../../router/app_router.dart';
import '../../service/user_service.dart';
import '../../view_model/squad_detail_view_model.dart';

class SquadDetailView extends StatefulWidget {
  final String tagName;
  const SquadDetailView({super.key, required this.tagName});

  @override
  State<SquadDetailView> createState() => _SquadDetailViewState();
}

class _SquadDetailViewState extends State<SquadDetailView> {
  String? currentUserId;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = await UserService.instance.getMe();
    setState(() {
      currentUserId = currentUser.id;
      isLoadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SquadDetailViewModel()..fetchSquad(widget.tagName),
      child: Scaffold(
        appBar: AppBar(
          title: null,
          titleSpacing: 0,
        ),
        body: isLoadingUser
            ? const Center(child: CircularProgressIndicator())
            : Consumer<SquadDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoadingSquad) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return Center(child: Text(viewModel.error!));
            }

            final squad = viewModel.squad!;
            final isAdmin = squad.adminList.any((admin) => admin.profileId == currentUserId);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(squad),
                _buildSquadActions(context, squad, viewModel),
                if (squad.description != null && squad.description!.isNotEmpty) _buildDescription(squad),
                const SizedBox(height: 16),
                _buildStats(squad),
                const SizedBox(height: 16),
                Expanded(
                  child: DefaultTabController(
                    length: isAdmin ? 2 : 1,
                    child: Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          tabs: [
                            const Tab(text: "Posts"),
                            if (isAdmin) const Tab(text: "Manage squad"),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              viewModel.isLoadingAvatars
                                  ? const Center(child: CircularProgressIndicator())
                                  : _buildPostList(squad, viewModel),
                              if (isAdmin) _buildManageSquad(squad),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(SquadResponse squad) {
    final avatarUrl = (squad.avatarUrl?.isNotEmpty ?? false)
        ? squad.avatarUrl!
        : AppConstants.urlImageDefault;
    final privacy = squad.privacy.toUpperCase();
    final tagName = squad.tagName;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(squad.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: privacy == 'PRIVATE' ? Colors.red[50] : Colors.blue[50],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          privacy == 'PRIVATE' ? Icons.lock : Icons.public,
                          size: 14,
                          color: privacy == 'PRIVATE' ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          privacy,
                          style: TextStyle(
                            fontSize: 12,
                            color: privacy == 'PRIVATE' ? Colors.red : Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(tagName, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquadActions(BuildContext context, SquadResponse squad, SquadDetailViewModel viewModel) {
    if (squad.canBeEdited) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.updateSquad, arguments: squad);
          },
          icon: const Icon(Icons.edit),
          label: const Text("Edit your squad"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    if (squad.joinStatus == "NOT_JOINED") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            final currentContext = context;

            try {
              showDialog(
                context: currentContext,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              final response = await UserService.instance.sendRequest(squad.tagName);
              if (!context.mounted) return;

              Navigator.of(currentContext).pop();

              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(content: Text(response.message ?? 'Request sent successfully')),
              );

              viewModel.updateSquadJoinStatus("PENDING");

            } catch (error) {
              if (!context.mounted) return;

              try {
                Navigator.of(currentContext).pop();
              } catch (_) {}

              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(
                  content: Text('Failed to send request: ${error.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Join squad"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    else if (squad.joinStatus == "PENDING") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text("Are you sure to cancel request ${squad.name}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final currentContext = context;
                        Navigator.of(dialogContext).pop();

                        try {
                          showDialog(
                            context: currentContext,
                            barrierDismissible: false,
                            builder: (BuildContext loadingContext) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          final response = await UserService.instance.cancelRequest(squad.tagName);
                          if (!context.mounted) return;

                          Navigator.of(currentContext).pop();

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(content: Text(response.message ?? 'Request canceled successfully')),
                          );

                          viewModel.updateSquadJoinStatus("NOT_JOINED");

                        } catch (error) {
                          if (!context.mounted) return;

                          try {
                            Navigator.of(currentContext).pop();
                          } catch (_) {}

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text('Failed to cancel request: ${error.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Confirm"),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.lock_clock, color: Colors.orange),
          label: const Text("Requested"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.orange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    } else if (squad.joinStatus == "JOINED" || squad.joinStatus == "ACCEPTED") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text("Are you sure to leave squad ${squad.name}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final currentContext = context;
                        Navigator.of(dialogContext).pop();

                        try {
                          showDialog(
                            context: currentContext,
                            barrierDismissible: false,
                            builder: (BuildContext loadingContext) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          final response = await UserService.instance.leaveSquad(squad.tagName);

                          if (!context.mounted) return;
                          Navigator.of(currentContext).pop();

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(content: Text(response.message ?? 'Leave squad successfully')),
                          );

                          viewModel.updateSquadJoinStatus("NOT_JOINED");

                        } catch (error) {
                          if (!context.mounted) return;

                          try {
                            Navigator.of(currentContext).pop();
                          } catch (_) {}

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text('Failed to cancel request: ${error.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Confirm"),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.check, color: Colors.green),
          label: const Text("Joined"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDescription(SquadResponse squad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("About this squad", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(squad.description ?? "", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(SquadResponse squad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Icon(Icons.people),
          const SizedBox(width: 4),
          Text("${squad.totalMembers} members"),
          const SizedBox(width: 16),
          const Icon(Icons.post_add),
          const SizedBox(width: 4),
          Text("${squad.totalPosts} posts"),
        ],
      ),
    );
  }

  Widget _buildPostList(SquadResponse squad, SquadDetailViewModel viewModel) {
    if (!viewModel.isLoadingPosts && viewModel.posts.isEmpty) {
      return const Center(
        child: Text(
          "Maybe this squad is empty.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: viewModel.scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: viewModel.posts.length + (viewModel.isLoadingPosts ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.posts.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final post = viewModel.posts[index];

        return CommonPost(
          post: post,
          onGetComment: () async {
            return await viewModel.getComment(post);
          },
        );
      },
    );
  }

  Widget _buildManageSquad(SquadResponse squad) {
    return const Center(child: Text("Manage squad tab content here..."));
  }
}
