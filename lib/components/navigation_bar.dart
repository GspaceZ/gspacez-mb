import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/utils/style.dart';

import '../screen/auth/introduce.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.3 * 255).toInt()),
              blurRadius: 6,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(height: 50,),
            Container(
              height: 0.5,
              color: Colors.grey,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: TextButton(
                style: buttonStyle,
                child: getOptions(
                  FlutterI18n.translate(context, "sidebar.home"),
                  const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: TextButton(
                style: buttonStyle,
                child: getOptions(
                  FlutterI18n.translate(context, "sidebar.search"),
                  const Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                onPressed: () {},
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: TextButton(
                style: buttonStyle,
                child: getOptions(
                  FlutterI18n.translate(context, "sidebar.profile"),
                  const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.updateProfile);
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: TextButton(
                style: buttonStyle,
                onPressed: () {},
                child: getOptions(
                  FlutterI18n.translate(context, "sidebar.your_pages"),
                  const Icon(
                    Icons.outlined_flag,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: TextButton(
                style: buttonStyle,
                onPressed: () {},
                child: getOptions(
                  FlutterI18n.translate(context, "sidebar.events"),
                  const Icon(
                    Icons.share_arrival_time_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: TextButton(
                style: buttonStyle,
                onPressed: () {},
                child: getOptions(
                  FlutterI18n.translate(context, "sidebar.upcoming_streams"),
                  SvgPicture.asset('assets/svg/airdrop.svg'),
                ),
              ),
            ),
            const Spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TextButton(
                style: buttonStyle,
                onPressed: () => _logOut(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                          FlutterI18n.translate(
                              context, "sidebar.logout_switch"),
                          overflow: TextOverflow.ellipsis,
                          style: textBold),
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

  Widget getOptions(String title, Widget icon) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textBold),
          icon,
        ],
      ),
    );
  }
}

_logOut(BuildContext context) {
  LocalStorage.instance.removeUserData();
  TokenDataSource.instance.deleteToken();
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const LayoutLanding(child: Introduce())));
}
