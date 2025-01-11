import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:untitled/data/local/token_data_source.dart';
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
  await dotenv.load(fileName: ".env");
  await i18nDelegate.load(
      const Locale('en')); // Load initial translations with non-null locale
  final isAuth = await TokenDataSource.instance.getToken() != null;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: MyApp(
        i18nDelegate,
        isAuth: isAuth,
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final FlutterI18nDelegate i18nDelegate;
  final bool isAuth;

  const MyApp(this.i18nDelegate, {super.key, required this.isAuth});

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
          initialRoute: widget.isAuth ? AppRoutes.home : AppRoutes.signIn,
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
                side: const BorderSide(
                    color: Colors.grey,
                    width: 0.5), // Set border color and width
                borderRadius:
                    BorderRadius.circular(10.0), // Set border radius if needed
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
