import 'package:flutter/material.dart';
import 'package:untitled/screen/auth/active_success.dart';
import 'package:untitled/screen/auth/forgot_password.dart';
import 'package:untitled/screen/auth/introduce.dart';
import 'package:untitled/screen/auth/signin.dart';
import 'package:untitled/screen/auth/signup.dart';
import 'package:untitled/screen/auth/waiting_active.dart';
import 'package:untitled/screen/default_layout.dart';
import 'package:untitled/screen/homePage/home.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/screen/profile/update_profile.dart';
import '../screen/profile/update_avatar.dart';

class AppRoutes {
  static const String splash_screen = '/';
  static const String sign_in = '/sign_in';
  static const String forgot_password = '/sign_in/forgot_password';
  static const String sign_up = '/sign_up';
  static const String home = '/home';
  static const String update_profile = '/update_profile';
  static const String update_avatar = '/update_avatar';
  static const String active_success = '/active_success';
  static const String waiting_active = '/waiting_active';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
            builder: (_) => const DefaultLayout(
                  selectedIndex: 4,
                  child: Home(),
                ));
      case splash_screen:
        return MaterialPageRoute(
          builder: (_) => const LayoutLanding(child: Introduce()),
        );
      case sign_in:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: SignIn()));
      case forgot_password:
        return MaterialPageRoute(
            builder: (_) => LayoutLanding(child: ForgotPassword()));
      case sign_up:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: SignUp()));
      case update_profile:
        return MaterialPageRoute(
            builder: (_) => const DefaultLayout(
                  selectedIndex: 4,
                  child: UpdateProfile(),
                ));
      case update_avatar:
        return MaterialPageRoute(
            builder: (_) => const DefaultLayout(
                  selectedIndex: 4,
                  child: UpdateAvatar(),
                ));
      case active_success:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: ActiveSuccess()));
      case waiting_active:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: WaitingActive()));
      default:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: Introduce()));
    }
  }
}
