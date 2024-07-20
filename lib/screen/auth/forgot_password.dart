import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/service/auth_service.dart';

import 'otp_screen.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

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
                        controller: emailController,
                        decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "auth.email"))
                            .getInputDecoration(),
                        validator: (value) => EmailValidator.validate(value!),
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
                        onPressed: () {
                          _sendEmail(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              FlutterI18n.translate(
                                  context, "auth.send_recovery_email"),
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

  Future<void> _sendEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context);
      try {
      final response = await forgetPassword(emailController.text);
      final data = jsonDecode(response.body);
      if (data['code'] == 1000) {
        LoadingDialog.hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Email sent successfully'),
          ),
        );
        LoadingDialog.hideLoadingDialog();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LayoutLanding(
                child: OtpScreen(
              email: emailController.text,
            )),
          ),
        );
      } else {
        LoadingDialog.hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Email not found'),
          ),
        );
      }
    } catch (error) {
      LoadingDialog.hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to send email. Please check your internet connection.'),
        ),
      );
      }
    }
  }
}
