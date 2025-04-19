import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/validators/password_validator.dart';
import 'package:untitled/service/user_service.dart';

class CreatePasswordView extends StatefulWidget {
  const CreatePasswordView({super.key});

  @override
  State<CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends State<CreatePasswordView> {
  final _formKey = GlobalKey<FormState>();

  final UserService _userService = UserService.instance;

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isConfirmObscureText = true;
  bool isNewObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Set the color of the container
          border: Border.all(
            color: Colors.grey, // Set the color of the border
            width: 0.5, // Set the width of the border
          ),
          borderRadius: BorderRadius.circular(16), // Set the border radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                FlutterI18n.translate(context, "auth.create_password"),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: newPasswordController,
                        decoration: CusTomInputDecoration(FlutterI18n.translate(
                                context, "auth.new_password"))
                            .getInputDecoration()
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isNewObscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isNewObscureText = !isNewObscureText;
                                  });
                                },
                              ),
                            ),
                        obscureText: isConfirmObscureText,
                        validator: (value) =>
                            PasswordValidator.validate(value!),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        decoration: CusTomInputDecoration(FlutterI18n.translate(
                                context, "auth.confirm_password"))
                            .getInputDecoration()
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmObscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmObscureText =
                                        !isConfirmObscureText;
                                  });
                                },
                              ),
                            ),
                        obscureText: isConfirmObscureText,
                        validator: (value) {
                          if (value != newPasswordController.text) {
                            return FlutterI18n.translate(context,
                                "auth.error_messages.password.confirm");
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () => _onConFirm(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              FlutterI18n.translate(context, "auth.confirm"),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onConFirm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context);
      try {
        await _userService.createNewPassword(newPasswordController.text);
        LoadingDialog.hideLoadingDialog();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                FlutterI18n.translate(context, "auth.create_password_success"),
              ),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        }
      } catch (error) {
        LoadingDialog.hideLoadingDialog();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                FlutterI18n.translate(context, "auth.create_password_fail"),
              ),
            ),
          );
        }
      }
    }
  }
}
