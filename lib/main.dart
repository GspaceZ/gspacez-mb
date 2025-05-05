import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/search_item_service.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/screen/auth/introduce.dart';
import 'package:untitled/screen/default_layout.dart';
import 'package:untitled/screen/layout_landing.dart';
import 'package:untitled/service/notification_service.dart';
import 'provider/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and register the adapter
  await Hive.initFlutter();
  SearchItemService.registerAdapter();
  await SearchItemService.initBox();

  // Initialize the Notification service
  await NotificationService().init();

  // Initialize the I18n delegate
  final i18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      useCountryCode: false,
      fallbackFile: 'en',
      basePath: 'assets/flutter_i18n',
      forcedLocale: const Locale('en'),
    ),
  );

// Load environment variables
  if (!kIsWeb) {
    await dotenv.load(fileName: ".env");
  }

  await i18nDelegate.load(const Locale('en'));

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
          initialRoute: widget.isAuth ? AppRoutes.search : AppRoutes.signIn,
          onGenerateRoute: AppRoutes.generateRoute,
          home: (widget.isAuth)
              ? const DefaultLayout(selectedIndex: AppConstants.home)
              : const LayoutLanding(child: Introduce()),
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
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            fontFamily: 'NotoSans',
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
