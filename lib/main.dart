import 'package:flutter/material.dart';
import 'package:sar_app/src/pages/home_page.dart';
import 'package:sar_app/src/pages/login_page.dart';
import 'package:sar_app/src/pages/solicitud_create_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sar App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // Spanish
        const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        SolicitudCreatePage.routeName: (BuildContext context) => SolicitudCreatePage(),
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(153, 0, 0, 1.0),
        accentColor: Color.fromRGBO(231, 76, 60,1.0),
      ),
    );
  }
}