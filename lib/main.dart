import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantapp/vue/profile.dart';
import 'package:plantapp/vue/welcome.dart';
import 'main1.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      debugShowCheckedModeBanner: false,
        title: 'Plantapp',
        color: Colors.white,
        builder: (context, _) {
          return Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return MaterialApp(
                title: 'Plantapp',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness:
                      settings.isDayNight ? Brightness.dark : Brightness.light,
                  primarySwatch: Colors.green,
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(fontSize: settings.fontSize),
                  ),
                ),
                initialRoute: '/',
                home: SplashScreen(),
                routes: {
                  
                  '/profile': (context) => Profile(),
                },
              );
            },
          );
        });
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkFirstSeen(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _checkFirstSeen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyApp1()),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Welcome()),
      );
    }
  }
}