import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/screen/auth/forgot_password.dart';
import 'package:untitled/screen/auth/signup.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/default_layout.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/service/auth_service.dart';

import '../component/dialog_loading.dart';
import '../layout_landing.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String email = "";
  String password = "";
  User? user;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
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
              padding: const EdgeInsets.only(top: 20.0, bottom: 24.0),
              child: Text(
                FlutterI18n.translate(context, "auth.sign_in"),
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
                        decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "auth.email"))
                            .getInputDecoration(),
                        validator: (value) => EmailValidator.validate(value!),
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "auth.password"))
                            .getInputDecoration()
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                        obscureText: !_isPasswordVisible,
                        controller: _passwordController,
                        onSaved: (value) {
                          password = value!;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LayoutLanding(child: ForgotPassword()),
                              ),
                            );
                          },
                          child: Text(
                            FlutterI18n.translate(
                                context, "auth.forgot_password"),
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Container(
                          width: 130,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                          child: Center(
                              child: Text(
                                  FlutterI18n.translate(
                                      context, "auth.sign_in"),
                                  style:
                                      const TextStyle(color: Colors.white)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              FlutterI18n.translate(
                                  context, "auth.not_have_account"),
                              style: const TextStyle(fontSize: 16)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LayoutLanding(
                                    child: SignUp(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              FlutterI18n.translate(context, "auth.sign_up"),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      LoadingDialog.showLoadingDialog(context);
      try {
        final response = await signIn(email, password);
        LoadingDialog.hideLoadingDialog();
        print(response);

        if (response['code'] == 1000) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(FlutterI18n.translate(
                  context, 'auth.sign_in_messages.success')),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DefaultLayout(selectedIndex: 0),
            ),
          );
        }
      } catch (e) {
        LoadingDialog.hideLoadingDialog();
        var errorMessage = FlutterI18n.translate(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
        if(errorMessage.length>30) {
          errorMessage = FlutterI18n.translate(context, "auth.sign_in_messages.fail");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(errorMessage),
          ),
        );
      }
    }
  }
}
