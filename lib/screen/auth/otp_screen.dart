import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:untitled/screen/auth/change_password.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/component/dialog_loading.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/service/auth_service.dart';

class OtpScreen extends StatelessWidget {
  final String email;

  OtpScreen({super.key, required this.email});

  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());

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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                FlutterI18n.translate(context, "auth.recover_account"),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                FlutterI18n.translate(context, "auth.description_otp"),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: CusTomInputDecoration("")
                            .getInputDecoration()
                            .copyWith(
                              counterText: "",
                            ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _otpFocusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
            TextButton(
              onPressed: () {
                _submit(context);
              },
              child: Container(
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: Center(
                      child: Text(
                          FlutterI18n.translate(context, "auth.confirm"),
                          style: const TextStyle(color: Colors.white)))),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context);
    // Validate the OTP
    final otp = _otpControllers.map((e) => e.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      try {
        final response = await verifyOtp(email, otp);
        LoadingDialog.hideLoadingDialog();
        final data = jsonDecode(response.body);
        if (data['code'] == 1000) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('OTP verified successfully'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LayoutLanding(
                child: ChangePassword(
                  email: email,
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('OTP verification failed'),
            ),
          );
        }
      } catch (e) {
        LoadingDialog.hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Please check your internet connection')),
        );
      }
    }
    // Navigate to the next screen
  }
}
