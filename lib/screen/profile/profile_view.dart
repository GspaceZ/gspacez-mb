import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;
  late ProfileViewModel _viewModel;

  // Theme colors
  final Color primaryColor = const Color(0xFF2563EB);
  final Color secondaryColor = const Color(0xFF3B82F6);
  final Color accentColor = const Color(0xFF60A5FA);
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF1F2937);
  final Color textSecondaryColor = const Color(0xFF6B7280);

  // Animation durations
  final Duration shortAnimation = const Duration(milliseconds: 200);
  final Duration mediumAnimation = const Duration(milliseconds: 400);
  final Duration longAnimation = const Duration(milliseconds: 600);

  // Thêm màu cho icons
  final Map<String, Color> iconColors = {
    'readme': const Color(0xFF0EA5E9), // Cyan
    'posts': const Color(0xFF10B981), // Emerald
    'upvoted': const Color(0xFFF59E0B), // Amber
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _viewModel = ProfileViewModel(profileTag: widget.profileTag);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    debugPrint('ProfileView: Returned from another screen');
    _viewModel.refreshAll();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _viewModel.updateCurrentTab(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textPrimaryColor,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => _viewModel,
        child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            return RefreshIndicator(
              color: primaryColor,
              backgroundColor: cardColor,
              onRefresh: () async {
                await viewModel.refreshAll();
              },
              child: NestedScrollView(
                controller: viewModel.mainScrollController,
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: mediumAnimation,
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: viewModel.isLoading
                          ? _buildLoadingUserInfo()
                          : _buildUserInfo(viewModel),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: primaryColor,
                        unselectedLabelColor: textSecondaryColor,
                        indicatorColor: primaryColor,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline,
                                    color: iconColors['readme']),
                                const SizedBox(width: 8),
                                const Text('Readme'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.post_add,
                                    color: iconColors['posts']),
                                const SizedBox(width: 8),
                                const Text('Posts'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.thumb_up,
                                    color: iconColors['upvoted']),
                                const SizedBox(width: 8),
                                const Text('Upvoted'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReadmeTab(viewModel),
                    _buildPostList(viewModel.listProfilePosts, viewModel),
                    _buildPostList(viewModel.listLikedPosts, viewModel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: longAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const CircleAvatar(radius: 50),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSquads() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: longAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(ProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Hero(
              tag: 'profile_avatar',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(viewModel.avatarUrl),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              viewModel.userName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
                letterSpacing: 0.5,
              ),
            ),
            if (viewModel.profileTag.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '@ ',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: viewModel.profileTag,
                      style: TextStyle(
                        color: textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildStatistics(viewModel),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: Colors.grey[200],
                thickness: 1,
              ),
            ),
            if (viewModel.country.isNotEmpty)
              _buildInfoRow(Icons.location_city, viewModel.country),
            if (viewModel.dateOfBirth.isNotEmpty)
              _buildInfoRow(Icons.calendar_month, viewModel.dateOfBirth),
            const SizedBox(height: 12),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(ProfileViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.post_add,
            color: iconColors['posts']!,
            label: 'Posts',
            value: viewModel.totalPost,
            isLoading: viewModel.isLoading,
          ),
          _buildStatItem(
            icon: Icons.group,
            color: iconColors['readme']!,
            label: 'Squads',
            value: viewModel.totalSquad,
            isLoading: viewModel.isLoading,
          ),
          _buildStatItem(
            icon: Icons.thumb_up,
            color: iconColors['upvoted']!,
            label: 'Upvoted',
            value: viewModel.totalUpvote,
            isLoading: viewModel.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    bool isLoading = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        isLoading
            ? Text(
                "---",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textSecondaryColor,
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color: secondaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return TextButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.updateProfile);
      },
      icon: Icon(Icons.edit, color: primaryColor, size: 14),
      label: Text(
        'Edit your profile',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildReadmeTab(ProfileViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        AnimatedSwitcher(
          duration: mediumAnimation,
          child: viewModel.isLoading
              ? _buildLoadingSquads()
              : _buildInvolvedSquad(viewModel),
        ),
        const SizedBox(height: 16),
        _buildOtherAccount(viewModel),
      ],
    );
  }

  Widget _buildInvolvedSquad(ProfileViewModel viewModel) {
    final context = navigatorKey.currentContext!;
    const maxDisplay = 10;
    final squads = viewModel.involvedSquads;
    final showMore = squads.length > maxDisplay;
    final displayedSquads =
        showMore ? squads.take(maxDisplay - 1).toList() : squads;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grid_view, color: Colors.indigo),
                  SizedBox(width: 10),
                  Text(
                    'Involved Squads',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, color: Colors.indigo),
                  SizedBox(width: 10),
                  Text(
                    'Social Accounts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
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
    if (viewModel.isLoading) {
      return _buildLoadingPosts();
    }

    return posts.isEmpty
        ? const Center(
            child: Text(
              'No posts available',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : ListView.builder(
            controller: viewModel.postsScrollController,
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

  Widget _buildLoadingPosts() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (overlapsContent)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
        ],
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
