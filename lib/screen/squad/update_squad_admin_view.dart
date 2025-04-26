import 'package:flutter/material.dart';
import 'package:untitled/model/admin_squad.dart';
import 'package:untitled/model/user_role.dart';

class UpdateSquadAdmin extends StatefulWidget {
  const UpdateSquadAdmin({super.key, required this.allUsers});

  final List<AdminSquad> allUsers;

  @override
  State<UpdateSquadAdmin> createState() => _UpdateSquadAdminState();
}

class _UpdateSquadAdminState extends State<UpdateSquadAdmin> {
  final TextEditingController _controller = TextEditingController();

  List<AdminSquad> suggestions = [];

  @override
  void initState() {
    super.initState();
    suggestions = widget.allUsers;
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        suggestions = widget.allUsers;
      } else {
        suggestions = widget.allUsers
            .where((user) =>
                user.profileName.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSuggestionTap(AdminSquad user) {
    ///TODO: call api to assign admin
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              hintText: "Search members",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 10),
          if (suggestions.isNotEmpty)
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final user = suggestions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Text(user.profileName),
                        const Spacer(),
                        (UserRole.admin.description == user.role)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.indigo),
                                    color: Colors.indigo),
                                child: Text(
                                  user.role.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  foregroundColor: Colors.indigo,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side:
                                        const BorderSide(color: Colors.indigo),
                                  ),
                                ),
                                onPressed: () => _onSuggestionTap(user),
                                child: const Text(
                                  "Assign Admin",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
