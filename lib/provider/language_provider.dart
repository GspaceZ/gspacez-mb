import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLocale(BuildContext context, Locale locale) async {
    _locale = locale;
    await FlutterI18n.refresh(context, locale);
    notifyListeners();
  }
}
