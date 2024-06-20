import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screen/default_layout.dart';

import 'provider/language_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final i18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      useCountryCode: false,
      fallbackFile: 'en',
      basePath: 'assets/flutter_i18n',
      forcedLocale: const Locale('en'),
    ),
  );

  await i18nDelegate.load(const Locale('en')); // Load initial translations with non-null locale

  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: MyApp(i18nDelegate),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate i18nDelegate;

  MyApp(this.i18nDelegate);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          localizationsDelegates: [
            i18nDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
          ],
          locale: languageProvider.locale,
          theme: ThemeData(
            fontFamily: 'NotoSans',
             // Set font chữ mặc định cho app
          ),
          home: const DefaultLayout(selectedIndex: 0),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}


