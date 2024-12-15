import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/provider/user_info_provider.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/service/user_service.dart';
import '../../router/app_router.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TokenDataSource _tokenDataSource = TokenDataSource.instance;
  final UserService _userService = UserService.instance;
  String pathAvatar = 'assets/svg/ic_avatar.svg';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = context.watch<UserInfoProvider>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.network(userInfoProvider.urlAvatar),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.updateAvatar);
                      },
                      child: Text(
                        FlutterI18n.translate(context, "profile.choose_avatar"),
                        style: const TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: CusTomInputDecoration(
                                    FlutterI18n.translate(
                                        context, "auth.first_name"))
                                .getInputDecoration(),
                            validator: (value) =>
                                FirstnameValidator.validate(value!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Optional: to give some space between the fields
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: CusTomInputDecoration(
                                    FlutterI18n.translate(
                                        context, "auth.last_name"))
                                .getInputDecoration(),
                            validator: (value) =>
                                LastnameValidator.validate(value!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nationController,
                      decoration: CusTomInputDecoration(
                              FlutterI18n.translate(context, "profile.country"))
                          .getInputDecoration(),
                      validator: (value) =>
                          InputDefaultValidator.validate(value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _cityController,
                      decoration: CusTomInputDecoration(
                              FlutterI18n.translate(context, "profile.city"))
                          .getInputDecoration(),
                      validator: (value) =>
                          InputDefaultValidator.validate(value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: CusTomInputDecoration(
                              FlutterI18n.translate(context, "profile.address"))
                          .getInputDecoration(),
                      validator: (value) =>
                          InputDefaultValidator.validate(value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _dateOfBirthController,
                      decoration: CusTomInputDecoration(
                              FlutterI18n.translate(context, "profile.dob"))
                          .getInputDecoration()
                          .copyWith(
                            suffixIcon: const Icon(Icons.calendar_month),
                          ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(
                            FocusNode()); // to prevent opening default keyboard
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _dateOfBirthController.text = pickedDate
                              .toIso8601String()
                              .substring(0, 10); // format: yyyy-mm-dd
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _submit();
                        },
                        child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.blue),
                            child: Center(
                                child: Text(
                                    FlutterI18n.translate(
                                        context, "profile.save"),
                                    style:
                                        const TextStyle(color: Colors.white)))),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1.5, color: Colors.blue.shade400),
                                color: Colors.white),
                            child: Center(
                                child: Text(
                                    FlutterI18n.translate(
                                        context, "profile.cancel"),
                                    style:
                                        const TextStyle(color: Colors.blue)))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final String? token = await _tokenDataSource.getToken();
      if (mounted) {
        LoadingDialog.showLoadingDialog(context);
      }
      try {
        final response = await _userService.updateProfile(
          _firstNameController.text,
          _lastNameController.text,
          _nationController.text,
          _cityController.text,
          _dateOfBirthController.text,
          _addressController.text,
          token!,
        );
        Log.debug(response.toString());
        if (response['code'] == 1000) {
          LoadingDialog.hideLoadingDialog();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Update profile successfully'),
              ),
            );
          }
        } else {
          LoadingDialog.hideLoadingDialog();
          if (mounted) {
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
        Log.debug(e.toString());
      }
    }
  }
}
