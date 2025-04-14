import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/view_model/squad_form_view_model.dart';

import '../../model/squad_response.dart';

class SquadFormView extends StatelessWidget {
  final SquadResponse? currentSquad;

  const SquadFormView({super.key, this.currentSquad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentSquad == null ? 'Create Squad' : 'Update your squad ${currentSquad?.tagName}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => SquadFormViewModel(
          currentSquad: currentSquad,
        ),
        child: Consumer<SquadFormViewModel>(
          builder: (context, squadFormViewModel, child) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      currentSquad == null ? "Create a place that people can interact with others about a topic" : "",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    /// Avatar
                    const Text(
                      "Upload your squad's avatar",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildUploadAvatarButton(squadFormViewModel),

                    /// Form input
                    _buildTextFormField(
                        "Name of your squad",
                        "Your squad's name",
                        squadFormViewModel.nameController,
                        Icons.label_outline),
                    _buildTextFormField("Tag name", "Find a tag name that can impress everyone",
                        squadFormViewModel.tagNameController, Icons.alternate_email),
                    _buildTextFormField("Description", "To help people know that your group will do",
                        squadFormViewModel.descriptionController, null,
                        isDescription: true),
                    const SizedBox(height: 16),
                    const Text(
                      "Choose your squad's privacy",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildCheckBox(
                        title: 'Public',
                        description:
                            'Anyone can see your squad and join without your approval',
                        value: squadFormViewModel.isPublic,
                        onChanged: (_) {
                          squadFormViewModel.togglePublic();
                        }),
                    _buildCheckBox(
                        title: 'Private',
                        description:
                            'Only members in the squads can interact with posts. Members can also send invitation link to join the squad.',
                        value: !squadFormViewModel.isPublic,
                        onChanged: (_) {
                          squadFormViewModel.togglePublic();
                        }),
                    const SizedBox(height: 16),

                    /// Advanced setting
                    _buildButtonAdvancedSetting(
                        squadFormViewModel.toggleAdvancedSettings,
                        squadFormViewModel.isShowAdvancedSetting),
                    if (squadFormViewModel.isShowAdvancedSetting) ...[
                      _buildSwitch(
                          title: 'Allow members to change profile',
                          description:
                              'Allow members to change their profile information',
                          value: squadFormViewModel.isAllowChangeProfile,
                          onChanged: (_) {
                            squadFormViewModel.toggleAllowChangeProfile();
                          }),
                      _buildSwitch(
                          title: 'Allow members to change post',
                          description:
                              'Allow members to change their post information',
                          value: squadFormViewModel.isAllowChangePost,
                          onChanged: (_) {
                            squadFormViewModel.toggleAllowChangePost();
                          }),
                      _buildSwitch(
                          title: 'Allow members to post under',
                          description:
                              'Allow members to post under other members post',
                          value: squadFormViewModel.isAllowPostUnder,
                          onChanged: (_) {
                            squadFormViewModel.toggleAllowPostUnder();
                          }),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: squadFormViewModel.submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit your new squad',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildUploadAvatarButton(SquadFormViewModel viewModel) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(navigatorKey.currentContext!).size.width * 0.4,
          height: MediaQuery.of(navigatorKey.currentContext!).size.width * 0.4,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFAAAAAA),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(140),
          ),
          child: CircleAvatar(
            radius: 140,
            backgroundColor: Colors.white54,
            backgroundImage: viewModel.uploadedImageUrl.isNotEmpty
                ? CachedNetworkImageProvider(viewModel.uploadedImageUrl)
                : null,
            child: viewModel.uploadedImageUrl.isEmpty
                ? TextButton(
                    onPressed: viewModel.onPressUpdateAvatar,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFFE6F1FE)),
                    ),
                    child: const Text(
                      "Upload Avatar",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: viewModel.onPressUpdateAvatar,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            side: WidgetStateProperty.all(
              const BorderSide(color: Colors.grey, width: 1),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: const Text(
            "Choose another image",
          ),
        )
      ],
    );
  }

  _buildButtonAdvancedSetting(
      VoidCallback onPressed, bool isShowAdvancedSetting) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'Advanced setting (Coming soon)',
                maxLines: 1,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            (isShowAdvancedSetting)
                ? const Icon(Icons.arrow_drop_up)
                : const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  _buildSwitch(
      {required String title,
      required String description,
      required bool value,
      Function(bool?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildCheckBox({
    required String title,
    required String description,
    required bool value,
    Function(bool?)? onChanged,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              shape: const CircleBorder(),
              activeColor: Colors.blue,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildTextFormField(String title, String labelText,
      TextEditingController controller, IconData? icon,
      {bool isDescription = false}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            const Text(
              '*',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: labelText,
            ),
            maxLines: isDescription ? 3 : 1,
            minLines: isDescription ? 3 : 1,
          ),
        ),
      ],
    );
  }
}
