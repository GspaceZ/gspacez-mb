import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/model/post_model_request.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/explore/explore_view.dart';
import 'package:untitled/screen/history/history_view.dart';
import 'package:untitled/screen/homePage/widgets/create_post.dart';
import 'package:untitled/screen/notification/notification_view.dart';
import 'package:untitled/service/post_service.dart';
import '../components/navigation_bar.dart';
import 'homePage/home.dart';

class DefaultLayout extends StatefulWidget {
  final int selectedIndex;
  final Widget? child;
  final String? title;

  const DefaultLayout(
      {super.key, required this.selectedIndex, this.child, this.title});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String urlAvatar = AppConstants.urlImageDefault;
  late AnimationController _hideBottomBarAnimationController;
  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.history,
    Icons.notifications_none,
  ];

  @override
  void initState() {
    _hideBottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    getUrlAvatar();
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  getUrlAvatar() async {
    urlAvatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          (_selectedIndex == 0)
              ? "Home"
              : (_selectedIndex == 1)
                  ? "Explore"
                  : (_selectedIndex == 2)
                      ? "History"
                      : (_selectedIndex == 3)
                          ? "Notifications"
                          : (_selectedIndex == 4)
                              ? "Create Squad"
                              : widget.title ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset('assets/svg/sidebar-right.svg'),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          _buildProfile(),
        ],
      ),
      drawer: const Drawer(
        child: NavigationSidebar(),
      ),
      body: Column(
        children: [
          const Divider(
            height: 1,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                /// Home page
                const Home(),

                /// Explore page
                const ExploreView(),
                /// History page
                const HistoryView(),

                /// Notification page
                const NotificationView(),

                if (widget.child != null) widget.child!,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        borderColor: Colors.grey,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        backgroundColor: Colors.white,
        hideAnimationController: _hideBottomBarAnimationController,
        onTap: (index) => setState(() => _selectedIndex = index),
        //other params
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1.1,
          child: CreatePostDialog(
            onCreatePost: createPost,
          ),
        );
      },
    );
  }

  Future<void> createPost(PostModelRequest postModelRequest) async {
    try {
      await PostService.instance.createPost(postModelRequest);
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  _buildProfile() {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      icon: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(urlAvatar),
      ),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.person_2_outlined),
              Text(" Profile"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.settings_outlined),
              Text(" Settings"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              Text(" Sign out", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            Navigator.pushNamed(
              context,
              AppRoutes.profile,
            );
            break;
          case 2:

            /// TODO: Navigate to Settings page
            break;
          case 3:
            _logOut();
            break;
        }
      },
    );
  }

  void _logOut() {
    LocalStorage.instance.removeUserData();
    TokenDataSource.instance.deleteToken();
    Navigator.pushReplacementNamed(
        context, AppRoutes.signIn); // Navigate to login page
  }
}
