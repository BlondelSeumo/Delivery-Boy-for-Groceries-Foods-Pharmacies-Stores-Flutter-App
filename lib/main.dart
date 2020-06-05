import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';

import 'generated/i18n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
//  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          print(_setting.toMap());
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: _setting.appName,
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage.value,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
              theme: _setting.brightness.value == Brightness.light
                  ? ThemeData(
                      fontFamily: 'ProductSans',
                      primaryColor: Colors.white,
                      floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,
                      accentColor: config.Colors().mainColor(1),
                      dividerColor: config.Colors().accentColor(0.05),
                      focusColor: config.Colors().accentColor(1),
                      hintColor: config.Colors().secondColor(1),
                      textTheme: TextTheme(
                        headline: TextStyle(fontSize: 22.0, color: config.Colors().secondColor(1)),
                        display1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1)),
                        display2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1)),
                        display3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                        display4: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
                        subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
                        title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                        body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1)),
                        body2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1)),
                        caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().accentColor(1)),
                      ),
                    )
                  : ThemeData(
                      fontFamily: 'ProductSans',
                      primaryColor: Color(0xFF252525),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF2C2C2C),
                      accentColor: config.Colors().mainDarkColor(1),
                      hintColor: config.Colors().secondDarkColor(1),
                      focusColor: config.Colors().accentDarkColor(1),
                      textTheme: TextTheme(
                        headline: TextStyle(fontSize: 22.0, color: config.Colors().secondDarkColor(1)),
                        display1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1)),
                        display2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1)),
                        display3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                        display4: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1)),
                        subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
                        title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                        body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1)),
                        body2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1)),
                        caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(0.6)),
                      ),
                    ));
        });
  }
}
