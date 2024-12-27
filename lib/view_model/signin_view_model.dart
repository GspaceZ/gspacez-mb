import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/components/dialog_loading.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/main.dart';
import 'package:untitled/service/auth_service.dart';
import 'package:untitled/service/user_service.dart';

import '../router/app_router.dart';

class SigninViewModel extends ChangeNotifier {
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
}
