import 'package:flutter/cupertino.dart';

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

  void submit() {
    /// TODO: Call API to create squad
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
