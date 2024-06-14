import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../provider/localeProvider.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
        actions: [
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              provider.setLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              return L10n.supportedLocales.map((Locale locale) {
                return PopupMenuItem<Locale>(
                  value: locale,
                  child: Text(L10n.getFlag(locale.languageCode)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(S.of(context).helloWorld),
      ),
    );
  }
}
