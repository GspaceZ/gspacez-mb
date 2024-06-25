import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/utils/style.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
    return Container(
      width: MediaQuery.of(context).size.width / 1.5 ,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Container(
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
                onPressed: () {},
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
          TextButton(
            style: buttonStyle,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LayoutLanding()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(FlutterI18n.translate(context, "sidebar.logout_switch"),
                      style: text_bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getOptions(String title, Widget icon) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: text_bold),
          icon,
        ],
      ),
    );
  }
}