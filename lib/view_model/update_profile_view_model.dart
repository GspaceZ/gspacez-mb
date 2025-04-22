import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/service/user_service.dart';
import '../model/country_model.dart';

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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  List<Country> countries = [];
  bool isLoadingCountries = false;

  Future<void> fetchCountries() async {
    isLoadingCountries = true;
    notifyListeners();

    try {
      final cached = await localStorage.getCountriesCache();
      if (cached != null) {
        final json = jsonDecode(cached);
        countries = (json['data'] as List)
            .map((e) => Country.fromJson(e))
            .toList();
        isLoadingCountries = false;
        notifyListeners();
        return;
      }

      final response = await http.get(Uri.parse('https://countriesnow.space/api/v0.1/countries/flag/images'));
      if (response.statusCode == 200) {
        await localStorage.saveCountriesCache(response.body); // Save to cache

        final json = jsonDecode(response.body);
        countries = (json['data'] as List)
            .map((e) => Country.fromJson(e))
            .toList();
      }
    } catch (e) {
      Log.error('fetchCountries error: $e');
    }

    isLoadingCountries = false;
    notifyListeners();
  }

  _init() async {
    await fetchCountries();
    pathAvatar =
        await localStorage.userUrlAvatar ?? AppConstants.urlImageDefault;
    firstNameController.text = await localStorage.firstName ?? '';
    lastNameController.text = await localStorage.lastName ?? '';
    nationController.text = await localStorage.nation ?? '';
    descriptionController.text = await localStorage.description ?? '';
    dateOfBirthController.text = await localStorage.dob ?? '';
    notifyListeners();
  }

  changeIsEdit({bool? newValue}) {
    isEdit = newValue ?? !isEdit;
    notifyListeners();
  }

  updateCountry(String countryName) {
    nationController.text = countryName;
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
            dateOfBirthController.text,
            descriptionController.text);
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
      localStorage.saveDescription(descriptionController.text),
      localStorage.saveDob(dateOfBirthController.text),
    ]);
  }
}
