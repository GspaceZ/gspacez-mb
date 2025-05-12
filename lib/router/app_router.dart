import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/screen/auth/active_success.dart';
import 'package:untitled/screen/auth/create_password_view.dart';
import 'package:untitled/screen/auth/forgot_password.dart';
import 'package:untitled/screen/auth/introduce.dart';
import 'package:untitled/screen/auth/signin.dart';
import 'package:untitled/screen/auth/signup.dart';
import 'package:untitled/screen/auth/waiting_active.dart';
import 'package:untitled/screen/chat_ai_view.dart';
import 'package:untitled/screen/discussions/discussion_view.dart';
import 'package:untitled/screen/explore/explore_view.dart';
import 'package:untitled/screen/feedback/feedback_view.dart';
import 'package:untitled/screen/history/history_view.dart';
import 'package:untitled/screen/homePage/post_detail_view.dart';
import 'package:untitled/screen/notification/notification_view.dart';
import 'package:untitled/screen/search/search_view.dart';
import 'package:untitled/screen/squad/squad_detail_view.dart';
import 'package:untitled/screen/squad/squad_form_view.dart';
import 'package:untitled/screen/default_layout.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/screen/profile/profile_view.dart';
import 'package:untitled/screen/profile/update_profile.dart';
import '../model/squad_response.dart';
import '../screen/discussions/discussion_detail.dart';
import '../screen/discussions/discussion_form.dart';
import '../screen/profile/update_avatar.dart';
import '../screen/tags/tag_view.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String signIn = '/sign_in';
  static const String forgotPassword = '/sign_in/forgot_password';
  static const String signUp = '/sign_up';
  static const String home = '/home';
  static const String history = '/history';
  static const String explore = '/explore';
  static const String updateProfile = '/update_profile';
  static const String updateAvatar = '/update_avatar';
  static const String activeSuccess = '/active_success';
  static const String waitingActive = '/waiting_active';
  static const String createNewPassword = '/create_password';
  static const String createSquad = '/create_squad';
  static const String updateSquad = '/update_squad';
  static const String chatAi = '/chat_ai';
  static const String profile = '/profile';
  static const String notification = '/notification';
  static const String squadDetail = '/squad_detail';
  static const String postDetail = '/post_detail';
  static const String feedBack = '/feedback';
  static const String tags = '/tags';
  static const String search = '/search';
  static const String discussions = '/discussions';
  static const String createDiscussion = '/discussions/create';
  static const String updateDiscussion = '/discussions/update';
  static const String detailDiscussion = '/discussions/detail';

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
        return MaterialPageRoute(builder: (_) => const UpdateProfile());
      case updateAvatar:
        return MaterialPageRoute(builder: (_) => const UpdateAvatar());
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
          builder: (_) => const SquadFormView(),
        );
      case updateSquad:
        final squad = settings.arguments as SquadResponse?;
        return MaterialPageRoute(
          builder: (_) => SquadFormView(currentSquad: squad),
        );
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryView());
      case explore:
        return MaterialPageRoute(builder: (_) => const ExploreView());
      case chatAi:
        return MaterialPageRoute(builder: (_) => const ChatAIView());
      case profile:
        final profileTag = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => ProfileView(profileTag: profileTag));
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      case squadDetail:
        final tagName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SquadDetailView(tagName: tagName),
        );
      case postDetail:
        final post = settings.arguments as PostModelResponse;
        return MaterialPageRoute(builder: (_) => PostDetailView(post: post));
      case feedBack:
        return MaterialPageRoute(
          builder: (_) => const FeedbackView(),
        );
      case tags:
        return MaterialPageRoute(
          builder: (_) => const TagView(),
        );
      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchView(),
        );
      case discussions:
        return MaterialPageRoute(
          builder: (_) => const DiscussionView(),
        );
      case createDiscussion:
        return MaterialPageRoute(
          builder: (_) => const DiscussionForm(),
        );
      case updateDiscussion:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DiscussionForm(id: id),
        );
      case detailDiscussion:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DiscussionDetail(id: id));
      default:
        return MaterialPageRoute(
            builder: (_) => const LayoutLanding(child: Introduce()));
    }
  }
}
