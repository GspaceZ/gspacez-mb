import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post.dart';
import 'package:untitled/main.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/view_model/profile_view_model.dart';
import '../../constants/appconstants.dart';
import '../squad/squad_detail_view.dart';

class ProfileView extends StatefulWidget {
  final String? profileId;
  const ProfileView({super.key, this.profileId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProfileViewModel _viewModel;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewModel = ProfileViewModel(profileId: widget.profileId);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _viewModel.updateCurrentTab(
            _tabController.index); // Update the view when tab is switched
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => _viewModel,
        child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            return NestedScrollView(
              controller: viewModel.scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(child: _buildUserInfo(viewModel)),
                SliverToBoxAdapter(child: _buildInvolvedSquad(viewModel)),
                SliverToBoxAdapter(child: _buildOtherAccount(viewModel)),
                SliverToBoxAdapter(
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Posts'),
                      Tab(text: 'Upvoted'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostList(viewModel.listProfilePosts, viewModel),
                  _buildPostList(viewModel.listLikedPosts, viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildUserInfo(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(viewModel.avatarUrl),
            ),
            const SizedBox(height: 10),
            Text(
              viewModel.userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if (viewModel.address.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_city),
                  const SizedBox(width: 5),
                  Text(viewModel.address),
                ],
              ),
            const SizedBox(height: 5),
            if (viewModel.dateOfBirth.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 5),
                  Text(viewModel.dateOfBirth),
                ],
              ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.updateProfile);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 5),
                  Text('Edit your profile', style: TextStyle(color: Colors.blue)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildInvolvedSquad(ProfileViewModel viewModel) {
    final context = navigatorKey.currentContext!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Involved Squads',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            (viewModel.involvedSquads.isEmpty)
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        'You haven\'t joined any squads yet. \n Join one to start your journey!',
                        style: TextStyle(color: Colors.grey)),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const avatarSize = 40.0;
                    const spacing = 12.0;
                    final countPerRow = (constraints.maxWidth + spacing) ~/
                        (avatarSize + spacing);
                    final totalSpacing =
                        constraints.maxWidth - (countPerRow * avatarSize);
                    final spacingBetween = countPerRow > 1
                        ? totalSpacing / (countPerRow - 1)
                        : totalSpacing;

                    return Wrap(
                      spacing: spacingBetween,
                      runSpacing: 12,
                      children: viewModel.involvedSquads.map((squad) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SquadDetailView(tagName: squad.tagName),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: avatarSize / 2,
                                backgroundImage: NetworkImage(
                                  squad.avatarUrl.isNotEmpty
                                      ? squad.avatarUrl
                                      : AppConstants.urlImageDefault,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Tooltip(
                                message: squad.name,
                                child: SizedBox(
                                  width: avatarSize + 20,
                                  child: Text(
                                    squad.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildOtherAccount(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'View other social accounts',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            (viewModel.otherUser.isEmpty)
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        'Add other accounts to your profile to manage them easily.',
                        style: TextStyle(color: Colors.grey)),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const avatarSize = 40.0;
                          const spacing = 12.0;
                          final countPerRow =
                              (constraints.maxWidth + spacing) ~/
                                  (avatarSize + spacing);
                          final totalSpacing =
                              constraints.maxWidth - (countPerRow * avatarSize);
                          final spacingBetween = countPerRow > 1
                              ? totalSpacing / (countPerRow - 1)
                              : totalSpacing;

                          return Wrap(
                            spacing: spacingBetween,
                            runSpacing: 12,
                            children: viewModel.involvedSquads.map((squad) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: avatarSize / 2,
                                    backgroundImage: NetworkImage(
                                      squad.avatarUrl.isNotEmpty == true
                                          ? squad.avatarUrl
                                          : AppConstants.urlImageDefault,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(
      List<PostModelResponse> posts, ProfileViewModel viewModel) {
    return (posts.isEmpty)
        ? const Center(
            child: Text(
              'No posts available',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return CommonPost(
                post: post,
                onGetComment: () async {
                  return await viewModel.getComment(post);
                },
              );
            },
          );
  }
}
