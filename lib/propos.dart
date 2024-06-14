import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart'; 

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(settings.selectedLanguage == 'Français' ? 'Conditions et termes d\'utilisations' : 'Terms and Conditions'
            , style: TextStyle(
              color: Colors.white,
            ),),
            backgroundColor: Color(0xFF569C3B),
          ),
          body: Container(
            color: settings.isDayNight? Color(0xFF1515): Color(0xFFE8F2E7),
            width: double.infinity,
            padding: EdgeInsets.all(16.0), // Marges pour éviter que le texte soit trop proche des bords
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.selectedLanguage == 'Français'
                          ? 'Conditions et termes d\'utilisation'
                          : 'Terms and Conditions',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      settings.selectedLanguage == 'Français'
                          ? 'Cette application vous permet de connaitre les bienfaits et les valeurs nutritionnelles des plantes. Pour utiliser cette application, il faut respecter les règles suivantes:'
                          : 'This application allows you to know the benefits and nutritional values of plants. To use this application, you must follow the following rules:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      settings.selectedLanguage == 'Français'
                          ? '1. Vous devez respecter les avis, les questions et les suggestions des autres utilisateurs et chaque utilisateur est libre de s\'exprimer dans la langue de son choix.'
                          : '1. You must respect the opinions, questions, and suggestions of other users, and each user is free to express themselves in the language of their choice.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      settings.selectedLanguage == 'Français'
                          ? '2. Vous ne devez pas avoir les propos violents et dangereux comme le sexe, la guerre, la drogue, la haine, le tribalisme, les fausses informations, le racisme, etc.'
                          : '2. You must not make violent and dangerous statements such as those related to sex, war, drugs, hatred, tribalism, false information, racism, etc.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      settings.selectedLanguage == 'Français'
                          ? '3. Avant de publier une information, une astuce ou une recette, vérifiez bien la véracité des informations avant de la partager avec les autres membres.'
                          : '3. Before publishing information, a tip, or a recipe, verify the accuracy of the information before sharing it with other members.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      settings.selectedLanguage == 'Français'
                          ? '4. Si vous ne respectez pas ces règles, le super administrateur est obligé de vous bloquer.'
                          : '4. If you do not follow these rules, the super administrator is obliged to block you.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
