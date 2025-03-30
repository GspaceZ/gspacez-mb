import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/screen/chat_ai_view.dart';
import 'package:untitled/screen/profile/update_profile.dart';
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

class _DefaultLayoutState extends State<DefaultLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          (_selectedIndex == 0)
              ? "Home"
              : (_selectedIndex == 1)
                  ? "Notifications"
                  : (_selectedIndex == 2)
                      ? "Chat with AI"
                      : (_selectedIndex == 3)
                          ? "Profile"
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

                /// Notifications page
                const Home(),

                /// Messages page
                const ChatAIView(),

                /// Profile page
                const UpdateProfile(),

                if (widget.child != null) widget.child!,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        selectedIndex: (_selectedIndex > 3) ? 3 : _selectedIndex,
        destinations: [
          NavigationDestination(
            // Home
            icon: getIcon(Icons.home_outlined, false),
            selectedIcon: getIcon(Icons.home_outlined, true),
            label: "",
          ),
          NavigationDestination(
            // Notifications
            icon: getIcon(Icons.notifications_none, false),
            selectedIcon: getIcon(Icons.notifications_none, true),
            label: "",
          ),
          NavigationDestination(
            // Messages
            icon: getIcon(Icons.messenger_outline, false),
            selectedIcon: getIcon(Icons.messenger_outline, true),
            label: "",
          ),
          NavigationDestination(
            // Profile
            icon: getIcon(Icons.account_circle_outlined, false),
            selectedIcon: (_selectedIndex == 3)
                ? getIcon(Icons.account_circle_outlined, true)
                : getIcon(Icons.account_circle_outlined, false),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget getIcon(IconData icon, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (isActive) ? Colors.black : Colors.grey.shade400,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: (isActive) ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
