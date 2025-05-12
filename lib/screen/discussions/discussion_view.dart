import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import 'discussion_card.dart';
import '../../view_model/discussion_view_model.dart';

class DiscussionView extends StatelessWidget {
  const DiscussionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiscussionViewModel(),
      child: Consumer<DiscussionViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text('Discussions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'To know what people on GspaceZ are talking about',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search discussions',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        vm.searchQuery = value;
                      },
                      onSubmitted: (value) async {
                        await vm.fetchDiscussions(isRefresh: true);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await vm.fetchDiscussions(isRefresh: true);
                      },
                      child: ListView.builder(
                        controller: vm.scrollController,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: vm.discussions.length + (vm.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < vm.discussions.length) {
                            return DiscussionCard(
                              discussion: vm.discussions[index],
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.createDiscussion);
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Create a discussion',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              backgroundColor: const Color(0xFF4C6EF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              elevation: 2,
            ),
          );
        },
      ),
    );
  }
}
