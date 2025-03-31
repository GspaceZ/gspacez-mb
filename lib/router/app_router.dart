import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/screen/auth/active_success.dart';
import 'package:untitled/screen/auth/create_password_view.dart';
import 'package:untitled/screen/auth/forgot_password.dart';
import 'package:untitled/screen/auth/introduce.dart';
import 'package:untitled/screen/auth/signin.dart';
import 'package:untitled/screen/auth/signup.dart';
import 'package:untitled/screen/auth/waiting_active.dart';
import 'package:untitled/screen/chat_ai_view.dart';
import 'package:untitled/screen/create_squad_view.dart';
import 'package:untitled/screen/default_layout.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/screen/profile/update_profile.dart';
import '../screen/profile/update_avatar.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String signIn = '/sign_in';
  static const String forgotPassword = '/sign_in/forgot_password';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String updateProfile = '/update_profile';
  static const String updateAvatar = '/update_avatar';
  static const String activeSuccess = '/active_success';
  static const String waitingActive = '/waiting_active';
  static const String createNewPassword = '/create_password';
  static const String createSquad = '/create_squad';
  static const String chatAi = '/chat_ai';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const DefaultLayout(
            selectedIndex: AppConstants.home,
          ),
        );
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: TokenDataSource.instance
                .getToken()
                .then((token) => token != null),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == true) {
                return const DefaultLayout(selectedIndex: AppConstants.home);
              } else {
                return const LayoutLanding(child: Introduce());
              }
            },
          ),
        );
      case signIn:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: SignIn()));
      case forgotPassword:
        return MaterialPageRoute(
            builder: (_) => LayoutLanding(child: ForgotPassword()));
      case signUp:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: SignUp()));
      case updateProfile:
        return MaterialPageRoute(
            builder: (_) => const DefaultLayout(
                  selectedIndex: AppConstants.profile,
                  child: UpdateProfile(),
                ));
      case updateAvatar:
        return MaterialPageRoute(
            builder: (_) => const DefaultLayout(
                  selectedIndex: AppConstants.custom,
                  child: UpdateAvatar(),
                ));
      case activeSuccess:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: ActiveSuccess()));
      case waitingActive:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: WaitingActive()));
      case createNewPassword:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: CreatePasswordView()));
      case createSquad:
        return MaterialPageRoute(
          builder: (_) => const DefaultLayout(
            selectedIndex: AppConstants.custom,
            child: CreateSquadView(),
          ),
        );
      case chatAi:
        return MaterialPageRoute(
            builder: (_) => const DefaultLayout(
                  selectedIndex: AppConstants.message,
                  child: ChatAIView(),
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: Introduce()));
    }
  }
}
