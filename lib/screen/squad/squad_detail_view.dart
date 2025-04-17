import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/model/admin_squad.dart';
import '../../components/common_post.dart';
import '../../model/squad_response.dart';
import '../../router/app_router.dart';
import '../../service/user_service.dart';
import '../../view_model/squad_detail_view_model.dart';
import '../profile/profile_view.dart';

class SquadDetailView extends StatefulWidget {
  final String tagName;
  const SquadDetailView({super.key, required this.tagName});

  @override
  State<SquadDetailView> createState() => _SquadDetailViewState();
}

class _SquadDetailViewState extends State<SquadDetailView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SquadDetailViewModel(widget.tagName),
      child: Consumer<SquadDetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: null,
              titleSpacing: 0,
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : (viewModel.error != null)
                    ? Center(child: Text(viewModel.error!))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(viewModel.squad),
                            _buildSquadActions(
                                context, viewModel.squad, viewModel),
                            const SizedBox(height: 16),
                            _buildSquadAdmins(context, viewModel.squad, viewModel),
                            if (viewModel.squad.description != null &&
                                viewModel.squad.description!.isNotEmpty)
                              _buildDescription(viewModel.squad),
                            const SizedBox(height: 16),
                            _buildStats(viewModel.squad),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 400,
                              child: DefaultTabController(
                                length: viewModel.isAdmin ? 2 : 1,
                                child: Column(
                                  children: [
                                    TabBar(
                                      isScrollable: true,
                                      tabs: [
                                        const Tab(text: "Posts"),
                                        if (viewModel.isAdmin)
                                          const Tab(text: "Manage squad"),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          viewModel.isLoadingPost
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : _buildPostList(
                                                  viewModel.squad, viewModel),
                                          if (viewModel.isAdmin)
                                            _buildManageSquad(viewModel.squad),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Squad name with tooltip and ellipsis
                    Expanded(
                      child: Tooltip(
                        message: squad.name,
                        child: Text(
                          squad.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Privacy badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: privacy == 'PRIVATE' ? Colors.red[50] : Colors.blue[50],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSquadActions(BuildContext context, SquadResponse squad,
      SquadDetailViewModel viewModel) {
    if (squad.canBeEdited) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.updateSquad,
                arguments: squad);
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
          onPressed: viewModel.joinSquad,
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
    } else if (squad.joinStatus == "PENDING") {
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

                          final response = await UserService.instance
                              .cancelRequest(squad.tagName);
                          if (!context.mounted) return;

                          Navigator.of(currentContext).pop();

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                                content: Text(response.message ??
                                    'Request canceled successfully')),
                          );

                          viewModel.updateSquadJoinStatus("NOT_JOINED");
                        } catch (error) {
                          if (!context.mounted) return;

                          try {
                            Navigator.of(currentContext).pop();
                          } catch (_) {}

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to cancel request: ${error.toString()}'),
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

                          final response = await UserService.instance
                              .leaveSquad(squad.tagName);

                          if (!context.mounted) return;
                          Navigator.of(currentContext).pop();

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                                content: Text(response.message ??
                                    'Leave squad successfully')),
                          );

                          viewModel.updateSquadJoinStatus("NOT_JOINED");
                        } catch (error) {
                          if (!context.mounted) return;

                          try {
                            Navigator.of(currentContext).pop();
                          } catch (_) {}

                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to cancel request: ${error.toString()}'),
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

  Widget _buildSquadAdmins(BuildContext context, SquadResponse squad, SquadDetailViewModel viewModel) {
    final admins = squad.adminList;

    if (admins.isEmpty) return const SizedBox.shrink();

    List<List<AdminSquad>> adminRows = [];
    for (int i = 0; i < admins.length; i += 2) {
      adminRows.add(
        admins.sublist(i, i + 2 > admins.length ? admins.length : i + 2),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Squad Admins",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ...adminRows.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: row.map((admin) {
                  final avatarUrl = viewModel.adminAvatars[admin.profileId];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileView(profileId: admin.profileId),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: avatarUrl != null
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              child: avatarUrl == null
                                  ? const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey,
                              )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              admin.profileName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDescription(SquadResponse squad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("About this squad",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 4),
                Text(
                  "${squad.totalMembers} members",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.post_add, size: 16),
                const SizedBox(width: 4),
                Text(
                  "${squad.totalPosts} posts",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(SquadResponse squad, SquadDetailViewModel viewModel) {
    if (!viewModel.isLoadingPost && viewModel.posts.isEmpty) {
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
      itemCount: viewModel.posts.length + (viewModel.isLoadingPost ? 1 : 0),
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
    return Column(
      children: [
        _buildListUser("Squad Admins", squad.adminList, isAdmin: true),
        _buildListUser("Member", []),
      ],
    );
  }

  _buildListUser(String title, List<AdminSquad> listAdmin,
      {bool isAdmin = false}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "$title (${listAdmin.length})",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: listAdmin.length * 60.0,
          child: ListView.builder(
            itemCount: listAdmin.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(listAdmin[index].avatarUrl),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  listAdmin[index].profileName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.indigo,
                                ),
                                child: Text(
                                  listAdmin[index].role.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Joined at ${DateFormat('dd/MM/yyyy').format(listAdmin[index].joinedAt)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: isAdmin
              ? ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade50,
                    padding: const EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Update your squad admins",
                    style: TextStyle(fontSize: 16, color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                )
              : (listAdmin.isEmpty)
                  ? const Center(
                      child: Text(
                        "No members found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : const SizedBox.shrink(),
        )
      ],
    );
  }
}
