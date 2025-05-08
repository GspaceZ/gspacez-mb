import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/view_model/signin_view_model.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SigninViewModel(),
      child: Consumer<SigninViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set the color of the container
                border: Border.all(
                  color: Colors.grey, // Set the color of the border
                  width: 0.5, // Set the width of the border
                ),
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 24.0),
                    child: Text(
                      FlutterI18n.translate(context, "auth.sign_in"),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: viewModel.formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: viewModel.emailController,
                              decoration: CusTomInputDecoration(
                                      FlutterI18n.translate(
                                          context, "auth.email"))
                                  .getInputDecoration(),
                              validator: (value) =>
                                  EmailValidator.validate(value!),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: CusTomInputDecoration(
                                      FlutterI18n.translate(
                                          context, "auth.password"))
                                  .getInputDecoration()
                                  .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        viewModel.isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed:
                                          viewModel.changeIsPasswordVisible,
                                    ),
                                  ),
                              obscureText: !viewModel.isPasswordVisible,
                              controller: viewModel.passwordController,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.forgotPassword);
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
                            onPressed: viewModel.submit,
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
                                        style: const TextStyle(
                                            color: Colors.white)))),
                          ),
                          _buildLoginWithGoogleButton(
                              onPressed: viewModel.signInWithGoogle),
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
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.signUp);
                                  },
                                  child: Text(
                                    FlutterI18n.translate(
                                        context, "auth.sign_up"),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
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
        },
      ),
    );
  }

  _buildLoginWithGoogleButton({required VoidCallback onPressed}) {
    final context = navigatorKey.currentContext!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
                color: Colors.white),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/ic_google.svg",
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(FlutterI18n.translate(context, "auth.sign_in_with_google"),
                    style: const TextStyle(color: Colors.blue)),
              ],
            ))),
      ),
    );
  }
}
