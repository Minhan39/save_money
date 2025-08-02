import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:save_money/assets/lang/language.dart';
import 'package:save_money/assets/theme/theme_managar.dart';
import 'package:save_money/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterLocalization.instance.ensureInitialized();

  await ThemeManager.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  final ThemeManager _themeManager = ThemeManager.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.en,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'vn',
          AppLocale.vn,
          countryCode: 'VN',
          fontFamily: 'Font VN',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;

    _themeManager.colorNotifier.addListener(_onColorChanged);

    super.initState();
  }

  @override
  void dispose() {
    _themeManager.colorNotifier.removeListener(_onColorChanged);
    super.dispose();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  void _onColorChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _themeManager.currentColor;

    final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        primary: primaryColor,
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: Colors.black,
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: Colors.black,
        surfaceTintColor: primaryColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: primaryColor.withValues(alpha: 0.2),
        elevation: 20,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );

    final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        primary: primaryColor,
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: primaryColor.withValues(alpha: 0.2),
        elevation: 20,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      themeMode: ThemeMode.system,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const LoginScreen(),
    );
  }
}
