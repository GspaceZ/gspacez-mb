
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider/user_info_provider.dart';
import 'package:untitled/router/app_router.dart';
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

  await i18nDelegate.load(
      const Locale('en')); // Load initial translations with non-null locale

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
      ],
      child: MyApp(i18nDelegate),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final FlutterI18nDelegate i18nDelegate;

  const MyApp(this.i18nDelegate, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.generateRoute,
          localizationsDelegates: [
            widget.i18nDelegate,
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
            popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 0.5), // Set border color and width
                borderRadius: BorderRadius.circular(10.0), // Set border radius if needed
              ),
            ),
            fontFamily: 'NotoSans',
            // Set font chữ mặc định cho app
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

}
