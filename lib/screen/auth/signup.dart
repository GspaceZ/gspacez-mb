import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/screen/auth/signin.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/component/dialog_loading.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/service/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool isObscureText = true;
  bool isConfirmObscureText = true;

  User? user;

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
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                FlutterI18n.translate(context, "auth.sign_up"),
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
                        controller: _emailController,
                        decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "auth.email"))
                            .getInputDecoration(),
                        validator: (value) => EmailValidator.validate(value!),
                      ),
                    ),
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
                        decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "auth.password"))
                            .getInputDecoration()
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscureText = !isObscureText;
                                  });
                                },
                              ),
                            ),
                        obscureText: isObscureText,
                        controller: _passwordController,
                        validator: (value) =>
                            PasswordValidator.validate(value!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _confirmPasswordController,
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
                          if (value != _passwordController.text) {
                            return FlutterI18n.translate(
                                context, "auth.confirm");
                          }
                          return null;
                        },
                      ),
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
                                      context, "auth.sign_up"),
                                  style:
                                      const TextStyle(color: Colors.white)))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            FlutterI18n.translate(context, "auth.have_account"),
                            style: const TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LayoutLanding(
                                  child: SignIn(),
                                ),
                              ),
                            );
                            // Navigate to the sign in screen
                          },
                          child: Text(
                            FlutterI18n.translate(context, "auth.sign_in"),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blue),
                          ),
                        )
                      ],
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
      user = User(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        password: _passwordController.text,
      );
      try {
        final response = await signUpUser(user!);
        LoadingDialog.hideLoadingDialog();
        if(response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Signed up successfully'),
            ),
          );
          Future.delayed(
              const Duration(seconds: 1),
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LayoutLanding(child:SignIn() ) ));
              }
          );
        }
      } catch (e) {
        LoadingDialog.hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Sign up failed. Please check your credentials.'),
          ),
        );
        print(e.toString());
        // Handle the error here
      }
    }
  }
}
