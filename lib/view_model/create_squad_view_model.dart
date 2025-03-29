import 'package:flutter/material.dart';
import '../components/dialog_loading.dart';
import '../main.dart';
import '../model/content_squad_model.dart';
import '../model/squad_setting.dart';
import '../service/squad_service.dart';

class CreateSquadViewModel extends ChangeNotifier {
  CreateSquadViewModel() {
    _init();
  }

  final nameSquadController = TextEditingController();
  final descriptionSquadController = TextEditingController();
  final tagSquadController = TextEditingController();
  bool isPublic = true;
  bool isShowAdvancedSetting = false;

  /// Advanced setting
  bool isAllowChangeProfile = false;
  bool isAllowChangePost = false;
  bool isAllowPostUnder = false;
  _init() async {
    notifyListeners();
  }

  void submit() async {
    try {
      LoadingDialog.showLoadingDialog(navigatorKey.currentContext);
      final contentSquad = ContentSquadModel(
        name: nameSquadController.text.trim(),
        tagName: tagSquadController.text.trim(),
        privacy: isPublic ? "PUBLIC" : "PRIVATE",
        description: descriptionSquadController.text.trim(),
        setting: SquadSetting(
          allowPostModeration: isAllowPostUnder,
          allowChangeProfileAccessibility: isAllowChangeProfile,
          allowPostInteraction: isAllowChangePost,
        ),
      );

      await SquadService.instance.createSquad(contentSquad);
      LoadingDialog.hideLoadingDialog();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Squad created successfully!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to create squad"),
        ),
      );
      throw Exception("Failed to create squad: $e");
    }
  }

  void onCheckPublic() {
    isPublic = !isPublic;
    notifyListeners();
  }

  void onChangeAllowChangeProfile() {
    isAllowChangeProfile = !isAllowChangeProfile;
    notifyListeners();
  }

  void onChangeAllowChangePost() {
    isAllowChangePost = !isAllowChangePost;
    notifyListeners();
  }

  void onChangeAllowPostUnder() {
    isAllowPostUnder = !isAllowPostUnder;
    notifyListeners();
  }

  void onChangeAdvancedSettingStatus() {
    isShowAdvancedSetting = !isShowAdvancedSetting;
    notifyListeners();
  }

  void onDispose() {
    nameSquadController.dispose();
    descriptionSquadController.dispose();
    tagSquadController.dispose();
  }
}
