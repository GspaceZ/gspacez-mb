import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/main.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/utils/style.dart';
import '../screen/auth/introduce.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "My Feed",
        "icon": Icons.library_books,
        "route": AppRoutes.home
      },
      {"title": "Explore", "icon": Icons.local_fire_department},
      {
        "title": "History",
        "icon": Icons.history,
        "route": AppRoutes.updateProfile
      },
    ];

    final List<Map<String, dynamic>> networkItems = [
      {"title": "Search Squads", "icon": Icons.square_foot},
      {"title": "Web Development", "icon": Icons.html},
      {"title": "Mobile Development", "icon": Icons.phone_android},
      {"title": "AI", "icon": Icons.analytics},
      {"title": "Database", "icon": Icons.storage},
      {"title": "Cloud", "icon": Icons.cloud},
    ];

    final List<Map<String, dynamic>> discoverItems = [
      {"title": "Tags", "icon": Icons.local_offer},
      {"title": "Discussions", "icon": Icons.chat},
    ];

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: withOpacityCompat(Colors.black, 0.3),
                blurRadius: 6,
                spreadRadius: 3),
          ],
        ),
        child: ListView(
          children: [
            _buildSectionHeader("Menu"),
            ...menuItems.map((item) => _buildMenuItem(context, item)),
            _buildSectionHeader("Network"),
            ...networkItems.map((item) => _buildMenuItem(context, item)),
            _buildCreateSquadButton(),
            _buildSectionHeader("Discover"),
            ...discoverItems.map((item) => _buildMenuItem(context, item)),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Text(title, style: textBold.copyWith(color: Colors.grey.shade700)),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.white),
        onPressed: item["route"] != null
            ? () => Navigator.pushReplacementNamed(context, item["route"])
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item["title"], style: textBold),
              Icon(item["icon"], color: Colors.black, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateSquadButton() {
    final context = navigatorKey.currentContext!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.createSquad);
            },
            child: const Row(
              children: [
                Text("Create Squad", style: TextStyle(color: Colors.blue)),
                SizedBox(width: 10),
                Icon(Icons.add, color: Colors.blue),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () => _logOut(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(FlutterI18n.translate(context, "sidebar.logout_switch"),
              style: textBold),
        ),
      ),
    );
  }

  void _logOut(BuildContext context) {
    LocalStorage.instance.removeUserData();
    TokenDataSource.instance.deleteToken();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LayoutLanding(child: Introduce())));
  }
}
