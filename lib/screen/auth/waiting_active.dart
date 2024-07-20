import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider/user_info_provider.dart';
import 'package:untitled/service/auth_service.dart';

class WaitingActive extends StatefulWidget {
  const WaitingActive({super.key});

  @override
  State<WaitingActive> createState() => _WaitingActiveState();
}

class _WaitingActiveState extends State<WaitingActive> {
  late UserInfoProvider userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = context.read<UserInfoProvider>();
    sendMail();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                FlutterI18n.translate(context, "auth.activate.welcome"),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                FlutterI18n.translate(context, "auth.activate.mail_sent"),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMail() async {
    try {
      final response = await sendMailActive(userInfo.email);
      if (response['code'] == 1000) {
        final uriActive = response['result']['urlEncoded'];
        print('Send mail success $uriActive');
      } else {
        print('Send mail failed');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }
}
