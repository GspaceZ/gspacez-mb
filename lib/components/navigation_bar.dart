import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/main.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/utils/style.dart';

import '../model/squad-access-response.dart';
import '../screen/squad/squad_detail_view.dart';
import '../service/squad_service.dart';

class NavigationSidebar extends StatefulWidget {
  const NavigationSidebar({super.key});

  @override
  State<NavigationSidebar> createState() => _NavigationSidebarState();
}

class _NavigationSidebarState extends State<NavigationSidebar> {
  bool showSearch = false;
  String searchQuery = '';
  bool isLoading = true;
  List<SquadAccessResponse> squads = [];
  bool isNetworkTabOpen = true;
  bool isAiTabOpen = false;
  bool isDiscoverTabOpen = false;

  @override
  void initState() {
    super.initState();
    fetchSquads();
  }

  Future<void> fetchSquads() async {
    try {
      final List<SquadAccessResponse> accessedSquads =
          await SquadService.instance.getLastAccess();
      setState(() {
        squads = accessedSquads;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch last accessed squads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> aiItems = [
      {"title": "AI", "icon": Icons.psychology, "route": AppRoutes.chatAi},
    ];

    final List<Map<String, dynamic>> discoverItems = [
      {"title": "Tags", "icon": Icons.tag},
      {"title": "Discussions", "icon": Icons.chat},
      {"title": "Feedback", "icon": Icons.feedback_outlined},
    ];

    final filteredSquads = searchQuery.isEmpty
        ? squads
        : squads
            .where((squad) =>
                squad.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

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
            _buildTabToggleButton("Network", () {
              setState(() {
                isNetworkTabOpen = !isNetworkTabOpen;
              });
            }, isOpen: isNetworkTabOpen),
            AnimatedSize(
              /// Network
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isNetworkTabOpen
                  ? Column(
                      children: [
                        _buildSearchSquads(),
                        if (showSearch) _buildSearchField(),
                        if (isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
                          ...filteredSquads
                              .map((squad) => _buildSquadItem(squad)),
                        _buildCreateSquadButton(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            _buildTabToggleButton("AI", () {
              setState(() {
                isAiTabOpen = !isAiTabOpen;
              });
            }, isOpen: isAiTabOpen),
            AnimatedSize(
              /// AI
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isAiTabOpen
                  ? Column(
                      children: aiItems
                          .map((item) => _buildMenuItem(context, item))
                          .toList(),
                    )
                  : const SizedBox.shrink(),
            ),
            _buildTabToggleButton("Discover", () {
              setState(() {
                isDiscoverTabOpen = !isDiscoverTabOpen;
              });
            }, isOpen: isDiscoverTabOpen),
            AnimatedSize(
              /// Discover
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isDiscoverTabOpen
                  ? Column(
                      children: discoverItems
                          .map((item) => _buildMenuItem(context, item))
                          .toList(),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTabToggleButton(String title, VoidCallback onTap,
      {bool isOpen = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textBold.copyWith(color: Colors.grey.shade700)),
            Icon(
              isOpen ? Icons.expand_less : Icons.expand_more,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSquads() {
    return InkWell(
      onTap: () {
        setState(() {
          showSearch = !showSearch;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Search squads", style: textBold),
            const Icon(Icons.manage_search_outlined,
                color: Colors.black, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildSquadItem(SquadAccessResponse squad) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          (squad.avatarUrl != null && squad.avatarUrl!.isNotEmpty)
              ? squad.avatarUrl!
              : AppConstants.urlImageDefault,
        ),
      ),
      title: Text(squad.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SquadDetailView(tagName: squad.tagName),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: item["route"] != null
          ? () => Navigator.pushNamed(context, item["route"])
          : null,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item["title"], style: textBold),
            Icon(item["icon"], color: Colors.black, size: 30),
          ],
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
