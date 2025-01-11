import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/main.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/service/auth_service.dart';
import 'package:untitled/service/user_service.dart';

import '../router/app_router.dart';

class SigninViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  User? user;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void changeIsPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  static final clientId = dotenv.env['CLIENT_ID'] ?? 'Client ID not found';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: clientId,
    scopes: [
      'email',
      'profile',
    ],
  );

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;

  SigninViewModel() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _currentUser = account;
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
    _googleSignIn.signInSilently();
  }

  Future<void> signInWithGoogle() async {
    LoadingDialog.showLoadingDialog(null);
    if (_currentUser != null) {
      await signOut();
    }
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      _currentUser = googleUser;
      final authCode = googleUser.serverAuthCode;
      if (authCode == null) {
        Log.error("Auth code is null");
      } else {
        Log.debug("Google user: $googleUser");
        final isSuccess = await AuthService.instance.sendCodeToServer(authCode);
        if (isSuccess) {
          Log.info("Sign in successfully");
          _saveUserInLocal();
          await _googleSignIn.signOut();
          LoadingDialog.hideLoadingDialog();
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                FlutterI18n.translate(navigatorKey.currentContext!,
                    "auth.sign_in_messages.success"),
              ),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 1000));
          final isNeededToCreatePassword =
              await UserService.instance.isNeededCreatePassword();
          if (isNeededToCreatePassword) {
            Navigator.pushReplacementNamed(
                navigatorKey.currentContext!, AppRoutes.createNewPassword);
            return;
          } else {
            Navigator.pushReplacementNamed(
                navigatorKey.currentContext!, AppRoutes.home);
          }
          return;
        } else {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                FlutterI18n.translate(
                    navigatorKey.currentContext!, "auth.sign_in_messages.fail"),
              ),
            ),
          );
        }
      }
    }
    await _googleSignIn.signOut();
    LoadingDialog.hideLoadingDialog();
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
      _currentUser = null;
      notifyListeners();
    } catch (error) {
      Log.error("Error signing out: $error");
    }
  }

  Future<void> submit() async {
    final context = navigatorKey.currentContext!;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      LoadingDialog.showLoadingDialog(context);
      try {
        final response = await _authService.signIn(
            emailController.text, passwordController.text);
        LoadingDialog.hideLoadingDialog();
        Log.debug(response.toString());

        if (response['code'] == 1000) {
          _saveUserInLocal();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(FlutterI18n.translate(
                    context, 'auth.sign_in_messages.success')),
              ),
            );
          }
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        }
      } catch (e) {
        LoadingDialog.hideLoadingDialog();
        if (context.mounted) {
          var errorMessage = FlutterI18n.translate(
            context,
            e.toString().replaceAll('Exception: ', ''),
          );
          if (errorMessage.length > 30) {
            errorMessage =
                FlutterI18n.translate(context, "auth.sign_in_messages.fail");
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

  Future<void> _saveUserInLocal() async {
    final profile = await UserService.instance.getProfile();
    final localStorage = LocalStorage.instance;
    localStorage.saveUserEmail(emailController.text);
    localStorage.saveUserName('${profile.firstName} ${profile.lastName}');
    localStorage.saveUserUrlAvatar(profile.avatarUrl);
    localStorage.saveUserId(profile.id);
    localStorage.saveFirstName(profile.firstName);
    localStorage.saveLastName(profile.lastName);
    localStorage.saveNation(profile.country ?? '');
    localStorage.saveCity(profile.city ?? '');
    localStorage.saveAddress(profile.address ?? '');
  }
}
