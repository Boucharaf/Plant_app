import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantapp/vue/profile.dart';
import '../settings_provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: settings.isDayNight ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.green,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: settings.fontSize),
            ),
          ),
          home: PlantasiaScreen(),
        );
      },
    );
  }
}

class PlantasiaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Image de fond
              Positioned.fill(
                child: Image.asset(
                  'assets/images/wallpaper.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Contenu
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Plantapp',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              // Bouton en bas
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      settings.selectedLanguage == 'Français'
                          ? 'Commencer maintenant'
                          : 'Start now',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
