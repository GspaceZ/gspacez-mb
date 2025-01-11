import 'package:flutter/material.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/service/user_service.dart';

class UpdateProfileViewModel extends ChangeNotifier {
  UpdateProfileViewModel() {
    _init();
  }

  final UserService _userService = UserService.instance;
  final localStorage = LocalStorage.instance;
  bool isEdit = false;
  String pathAvatar = AppConstants.urlImageDefault;
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  _init() async {
    pathAvatar =
        await localStorage.userUrlAvatar ?? AppConstants.urlImageDefault;
    firstNameController.text = await localStorage.firstName ?? '';
    lastNameController.text = await localStorage.lastName ?? '';
    nationController.text = await localStorage.nation ?? '';
    cityController.text = await localStorage.city ?? '';
    addressController.text = await localStorage.address ?? '';
    notifyListeners();
  }

  changeIsEdit({bool? newValue}) {
    isEdit = newValue ?? !isEdit;
    notifyListeners();
  }

  Future<void> submit() async {
    final context = formKey.currentContext!;
    if (formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context);
      try {
        final response = await _userService.updateProfile(
            firstNameController.text,
            lastNameController.text,
            nationController.text,
            cityController.text,
            dateOfBirthController.text,
            addressController.text);
        Log.debug(response.toString());
        if (response['code'] == 1000) {
          LoadingDialog.hideLoadingDialog();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Update profile successfully'),
              ),
            );
          }
          _updateUserInfoLocal();
        } else {
          LoadingDialog.hideLoadingDialog();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Failed to update profile'),
              ),
            );
          }
        }
      } catch (e) {
        LoadingDialog.hideLoadingDialog();
        Log.debug(e);
      }
    }
  }

  _updateUserInfoLocal() {
    Future.wait([
      localStorage.saveFirstName(firstNameController.text),
      localStorage.saveLastName(lastNameController.text),
      localStorage.saveNation(nationController.text),
      localStorage.saveCity(cityController.text),
      localStorage.saveAddress(addressController.text),
    ]);
  }
}
