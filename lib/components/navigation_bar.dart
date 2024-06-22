import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/utils/style.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
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
          TextButton(
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
          const Divider(),
          TextButton(
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
          const Divider(),
          TextButton(
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
          const Divider(),
          TextButton(
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
          const Divider(),
          TextButton(
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
          const Divider(),
          TextButton(
            onPressed: () {},
            child: getOptions(
              FlutterI18n.translate(context, "sidebar.upcoming_streams"),
              SvgPicture.asset('assets/svg/airdrop.svg'),
            ),
          ),
          const Spacer(),
          const Divider(),
          TextButton(
            onPressed: () {},
            child: Text(FlutterI18n.translate(context, "sidebar.logout_switch"),
                style: text_bold),
          ),
        ],
      ),
    );
  }

  Widget getOptions(String title, Widget icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
