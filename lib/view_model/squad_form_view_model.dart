import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/screen/crop_image_dialog.dart';

import '../components/dialog_loading.dart';
import '../main.dart';
import '../model/content_squad_model.dart';
import '../model/squad_response.dart';
import '../model/squad_setting.dart';
import '../service/cloudinary_service.dart';
import '../service/squad_service.dart';

class SquadFormViewModel extends ChangeNotifier {
  final SquadResponse? currentSquad;

  SquadFormViewModel({this.currentSquad}) {
    _init();
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagNameController = TextEditingController();
  bool isPublic = true;
  bool isShowAdvancedSetting = false;

  String uploadedImageUrl = "";

  bool isAllowChangeProfile = false;
  bool isAllowChangePost = false;
  bool isAllowPostUnder = false;

  void _init() {
    if (currentSquad != null) {
      final squad = currentSquad!;
      nameController.text = squad.name;
      descriptionController.text = squad.description ?? '';
      tagNameController.text = squad.tagName;
      uploadedImageUrl = squad.avatarUrl ?? '';
      isPublic = (squad.privacy) == "PUBLIC";

      isAllowChangeProfile = squad.setting.allowChangeProfileAccessibility;
      isAllowChangePost = squad.setting.allowChangeInteraction;
      isAllowPostUnder = squad.setting.allowPostModeration;
    }

    notifyListeners();
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final context = navigatorKey.currentContext!;
    if (context.mounted) {
      LoadingDialog.showLoadingDialog(context);
    }

    try {
      uploadedImageUrl =
          await CloudinaryService.instance.uploadImage(pickedFile.path);
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload image"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      LoadingDialog.hideLoadingDialog();
    }
  }

  void onPressUpdateAvatar() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1.1,
          child: CropImageDialog(
            voidCallback: (_) => pickAndUploadImage(),
          ),
        );
      },
    );
  }

  Future<void> submit() async {
    final context = navigatorKey.currentContext!;
    try {
      LoadingDialog.showLoadingDialog(context);

      final content = ContentSquadModel(
        name: nameController.text.trim(),
        tagName: tagNameController.text.trim(),
        avatarUrl: uploadedImageUrl,
        privacy: isPublic ? "PUBLIC" : "PRIVATE",
        description: descriptionController.text.trim(),
        setting: SquadSetting(
          allowPostModeration: isAllowPostUnder,
          allowChangeProfileAccessibility: isAllowChangeProfile,
          allowChangeInteraction: isAllowChangePost,
        ),
      );

      if (currentSquad != null) {
        await SquadService.instance.updateSquad(content, currentSquad!.tagName);
        _showSnackBar("Squad updated successfully!", Colors.green);
      } else {
        await SquadService.instance.createSquad(content);
        _showSnackBar("Squad created successfully!", Colors.green);
      }
    } catch (e) {
      _showSnackBar(
          "Failed to ${currentSquad != null ? 'update' : 'create'} squad",
          Colors.red);
      throw Exception("Error: $e");
    } finally {
      LoadingDialog.hideLoadingDialog();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _showSnackBar(String msg, Color color) {
    final context = navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  // State toggles
  void togglePublic() {
    isPublic = !isPublic;
    notifyListeners();
  }

  void toggleAllowChangeProfile() {
    isAllowChangeProfile = !isAllowChangeProfile;
    notifyListeners();
  }

  void toggleAllowChangePost() {
    isAllowChangePost = !isAllowChangePost;
    notifyListeners();
  }

  void toggleAllowPostUnder() {
    isAllowPostUnder = !isAllowPostUnder;
    notifyListeners();
  }

  void toggleAdvancedSettings() {
    isShowAdvancedSetting = !isShowAdvancedSetting;
    notifyListeners();
  }

  void disposeControllers() {
    nameController.dispose();
    descriptionController.dispose();
    tagNameController.dispose();
  }
}
