
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

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
  bool isDialogMenu = false;
  int _selectedIndex = 0;
  List<int> check = [0, 0, 0, 0, 0];
  final GlobalKey _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
              height: screenHeight * 0.04,
            ),
            SizedBox(
              height: screenHeight * 0.08 - 1,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (isDialogMenu == false) {
                                  isDialogMenu = true;
                                } else {
                                  isDialogMenu = false;
                                }
                                setState(() {});
                              },
                              icon: SvgPicture.asset(
                                  'assets/svg/sidebar-right.svg')),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      FlutterI18n.translate(context, "title.home"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ][_selectedIndex],
                ],
              ),
            ),
            SizedBox(
              //bottom navigation bar
              height: screenHeight * 0.1,
              child: NavigationBar(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorShape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                indicatorColor: Colors.transparent,
                onDestinationSelected: (int index) {
                  if( check[index] == 1){
                    _selectedIndex = 4;
                    check = [0, 0, 0, 0, 0];
                  }
                  else {
                    check = [0, 0, 0, 0, 0];
                    check[index] = 1;
                    _selectedIndex = index;
                  }
                  setState(() {
                  });
                },
                selectedIndex: (_selectedIndex>3) ? 3 : _selectedIndex,

                destinations : [
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
                    selectedIcon: (_selectedIndex == 3) ? getIcon('assets/svg/activity.svg', true) : getIcon('assets/svg/activity.svg', false),
                    label: "",
                  ),
                ],
              ),
            )
          ],
        ),
        _buildMenu(),
        closeMenu(),
      ]),
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

  Widget _buildMenu() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      left: isDialogMenu ? 0 : -MediaQuery.of(context).size.width / 1.5,
      top: 0,
      bottom: 0,
      child: Container(key: _containerKey, child: const NavigationSidebar()),
    );
  }

  Widget closeMenu() {
    return Visibility(
      visible: isDialogMenu,
      child: Positioned(
          right: 0,
          child: InkWell(
            onTap: () {
              isDialogMenu = false;
              setState(() {});
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * (1 / 3),
              height: MediaQuery.of(context).size.height,
            ),
          )),
    );
  }
}