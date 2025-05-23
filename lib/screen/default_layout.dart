import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/post_model_request.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/explore/explore_view.dart';
import 'package:untitled/screen/history/history_view.dart';
import 'package:untitled/screen/homePage/widgets/create_post.dart';
import 'package:untitled/screen/notification/notification_view.dart';
import 'package:untitled/service/event_bus_service.dart';
import 'package:untitled/service/post_service.dart';

import '../components/navigation_bar.dart';
import '../service/user_service.dart';
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
  String profileId = "";
  String profileTag = "";
  late AnimationController _hideBottomBarAnimationController;
  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.search,
    Icons.history,
    Icons.notifications_none,
  ];
  int streakCount = 0;
  bool isNotificationBadge = false;
  final eventBus = KeyedEventBus();

  @override
  void initState() {
    eventBus.listener<int>(AppConstants.keyNotification).listen((data) {
      Log.info("Received notification: $data");
      isNotificationBadge = true;
      setState(() {});
    });
    _hideBottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    getProfile();
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    eventBus.disposeKey(AppConstants.keyNotification);
    super.dispose();
  }

  getProfile() async {
    urlAvatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    profileId = await LocalStorage.instance.userId ?? "";
    profileTag = await LocalStorage.instance.userTag ?? "";
    setState(() {});

    if (profileId.isNotEmpty) {
      getStreak();
    }
  }

  getStreak() async {
    if (profileId.isEmpty) return;

    try {
      final result = await UserService.instance.getStreak(profileTag);
      setState(() {
        streakCount = result.currentStreak;
      });
    } catch (e) {
      Log.error('Error getting streak: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.black : Colors.grey;

          Widget icon = Icon(
            iconList[index],
            color: color,
            size: 24,
          );

          // Nếu là tab notification + có badge
          if (index == 3 && isNotificationBadge) {
            icon = Badge(
              alignment: Alignment.topRight,
              offset: const Offset(3, -3),
              backgroundColor: Colors.red,
              label: const Text(
                '!',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              child: icon,
            );
          }

          return Center(
            child: SizedBox(
              height: 32,
              width: 32,
              child: icon,
            ),
          );
        },
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        borderColor: Colors.grey,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        backgroundColor: Colors.white,
        hideAnimationController: _hideBottomBarAnimationController,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          isNotificationBadge = false; // Reset notification badge
        }),
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
      final response = await PostService.instance.createPost(postModelRequest);
      eventBus.sink(AppConstants.keyCreatePost, response);
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  _buildProfile() {
    return Row(
      children: [
        const SizedBox(width: 8),
        _buildStreak(),
        PopupMenuButton(
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
                  Icon(Icons.logout_outlined, color: Colors.red),
                  Text(" Sign out", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 1:
                Navigator.pushNamed(context, AppRoutes.profile);
                break;
              case 2:
                break;
              case 3:
                _logOut();
                break;
            }
          },
        ),
      ],
    );
  }

  _buildStreak() {
    return Tooltip(
      message: "You have $streakCount days of streak",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange),
            const SizedBox(width: 4),
            Text(
              "$streakCount",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logOut() {
    LocalStorage.instance.removeUserData();
    TokenDataSource.instance.deleteToken();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.signIn,
      (Route<dynamic> route) => false,
    ); // Navigate to login page
  }
}
