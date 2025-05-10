import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/view_model/profile_view_model.dart';
import '../../components/common_post_simple.dart';
import '../../constants/appconstants.dart';

class ProfileView extends StatefulWidget {
  final String? profileTag;
  const ProfileView({super.key, this.profileTag});

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
    _viewModel = ProfileViewModel(profileTag: widget.profileTag);
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
            if (viewModel.profileTag.isNotEmpty)
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '@ ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: viewModel.profileTag,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            const SizedBox(height: 15),
            if (viewModel.country.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_city),
                  const SizedBox(width: 5),
                  Text(viewModel.country),
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
                  Text('Edit your profile',
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInvolvedSquad(ProfileViewModel viewModel) {
    final context = navigatorKey.currentContext!;
    const maxDisplay = 10;
    final squads = viewModel.involvedSquads;
    final showMore = squads.length > maxDisplay;
    final displayedSquads = showMore ? squads.take(maxDisplay - 1).toList() : squads;
    final hiddenSquadsCount = squads.length - displayedSquads.length;

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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const Divider(),
            if (squads.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'You haven\'t joined any squads yet. \n Join one to start your journey!',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...displayedSquads.map((squad) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.squadDetail,
                          arguments: squad.tagName,
                        );
                      },
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(squad.name),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          squad.avatarUrl.isNotEmpty
                              ? squad.avatarUrl
                              : AppConstants.urlImageDefault,
                        ),
                      ),
                    )),
                    if (showMore)
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          '+$hiddenSquadsCount',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            if (squads.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.search);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Find more squads',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
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
                'Social Accounts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const Divider(),
            (viewModel.socialMedias.isEmpty)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSocialButton(
                      text: 'Connect Twitter',
                      iconPath: 'assets/images/twitter.png',
                      backgroundColor: const Color(0xFFE8F5FE),
                      textColor: const Color(0xFF228BE6),
                    ),
                    _buildSocialButton(
                      text: 'Connect LinkedIn',
                      iconPath: 'assets/images/linkedin.png',
                      backgroundColor: const Color(0xFFE6F0FA),
                      textColor: const Color(0xFF4C6EF5),
                    ),
                    _buildSocialButton(
                      text: 'Connect GitHub',
                      iconPath: 'assets/images/github.png',
                      backgroundColor: const Color(0xFFF2F2F2),
                      textColor: const Color(0xFF886E96),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSocialButton({
    required String text,
    required String iconPath,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(iconPath, width: 20, height: 20),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 50),
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
              return CommonPostSimple(
                post: post,
              );
            },
          );
  }
}
