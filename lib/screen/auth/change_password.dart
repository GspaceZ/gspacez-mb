import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:untitled/screen/auth/signin.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/service/auth_service.dart';

class ChangePassword extends StatelessWidget {
  final String email;
  ChangePassword({super.key, required this.email});
  final AuthService _authService = AuthService.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                FlutterI18n.translate(context, "auth.forgot_password"),
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
                        controller: passwordController,
                        decoration: CusTomInputDecoration(FlutterI18n.translate(
                                context, "auth.new_password"))
                            .getInputDecoration(),
                        validator: (value) =>
                            PasswordValidator.validate(value!),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: CusTomInputDecoration(
                                  FlutterI18n.translate(
                                      context, "auth.confirm_password"))
                              .getInputDecoration(),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return FlutterI18n.translate(context,
                                  "auth.error_messages.password.confirm");
                            }
                            return null;
                          }),
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
                        onPressed: () {
                          _submitForm(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              FlutterI18n.translate(
                                  context, "auth.change_password"),
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

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context);
      try {
        final response = await _authService.resetPassword(
            email, confirmPasswordController.text);
        final data = jsonDecode(response.body);
        if (data['code'] == 1000) {
          LoadingDialog.hideLoadingDialog();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Password changed successfully. Please sign in.'),
              ),
            );
          }
          LoadingDialog.hideLoadingDialog();
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LayoutLanding(child: SignIn()),
              ),
            );
          }
        } else {
          LoadingDialog.hideLoadingDialog();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Failed to change password. Please try again.'),
              ),
            );
          }
        }
      } catch (error) {
        LoadingDialog.hideLoadingDialog();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to change password. Please try again.'),
            ),
          );
        }
      }
    }
  }
}
