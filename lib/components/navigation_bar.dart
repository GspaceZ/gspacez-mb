import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/utils/style.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> networkItems = [
      {"title": "Search Squads", "icon": Icons.manage_search_outlined},
      {"title": "Web Development", "icon": Icons.html},
      {"title": "Mobile Development", "icon": Icons.phone_android},
      {"title": "Database", "icon": Icons.storage},
      {"title": "Cloud", "icon": Icons.cloud},
    ];

    final List<Map<String, dynamic>> aiItems = [
      {"title": "AI", "icon": Icons.psychology, "route": AppRoutes.chatAi},
    ];

    final List<Map<String, dynamic>> discoverItems = [
      {"title": "Tags", "icon": Icons.tag},
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
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 3),
          ],
        ),
        child: ListView(
          children: [
            _buildSectionHeader("Network"),
            ...networkItems.map((item) => _buildMenuItem(context, item)),
            _buildCreateSquadButton(),
            _buildSectionHeader("AI"),
            ...aiItems.map((item) => _buildMenuItem(context, item)),
            _buildSectionHeader("Discover"),
            ...discoverItems.map((item) => _buildMenuItem(context, item)),
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
            ? () => Navigator.pushNamed(context, item["route"])
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
}
