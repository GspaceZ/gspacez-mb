import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/navigation_bar.dart';
import '../components/trending_sidebar.dart';
import 'homePage/home.dart';

class DefaultLayout extends StatefulWidget {
  final int selectedIndex;

  const DefaultLayout({super.key, required this.selectedIndex});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  int _selectedIndex = 0;
  List<int> check = [0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "title.home"),
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
            child: Stack(
              children: [
                <Widget>[
                  /// Home page
                  const Home(),

                  /// Notifications page
                  const Home(),

                  /// Messages page
                  const Home(),

                  /// Activity page
                  const TrendingSidebar(),
                  const Center(
                    child: Text(
                      "Home Page",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ][_selectedIndex],
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
          if (check[index] == 1) {
            _selectedIndex = 4;
            check = [0, 0, 0, 0, 0];
          } else {
            check = [0, 0, 0, 0, 0];
            check[index] = 1;
            _selectedIndex = index;
          }
          setState(() {});
        },
        selectedIndex: (_selectedIndex > 3) ? 3 : _selectedIndex,
        destinations: [
          NavigationDestination(
            icon: getIcon("assets/svg/send-2.svg", false),
            selectedIcon: getIcon("assets/svg/send-2.svg", true),
            label: "",
          ),
          NavigationDestination(
            icon: getIcon('assets/svg/notification.svg', false),
            selectedIcon: getIcon('assets/svg/notification.svg', true),
            label: "",
          ),
          NavigationDestination(
            icon: getIcon('assets/svg/setting-2.svg', false),
            selectedIcon: getIcon('assets/svg/setting-2.svg', true),
            label: "",
          ),
          NavigationDestination(
            icon: getIcon('assets/svg/activity.svg', false),
            selectedIcon: (_selectedIndex == 3)
                ? getIcon('assets/svg/activity.svg', true)
                : getIcon('assets/svg/activity.svg', false),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget getIcon(String path, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (isActive) ? Colors.black : Colors.grey.shade400,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          path,
          color: (isActive) ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
