import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart'; // Importez la classe SettingsProvider

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Changer de langue'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('Français'),
                  onTap: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setLanguage('Français');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('English'),
                  onTap: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .setLanguage('English');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: settings.isDayNight? Color(0xFF1515): Color(0xFFE8F2E7),
      appBar: AppBar(
        title: Text(settings.selectedLanguage == 'Français' ? 'Paramètres' : 'Settings',
        style: TextStyle(

        color: Colors.white),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: settings.isDayNight? Color(0xFF1515): Color(0xFFE8F2E7),
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildSettingCard(
                context,
                title: settings.selectedLanguage == 'Français' ? 'Jour/Nuit' : 'Day/Night',
                trailing: Switch(
                  value: settings.isDayNight,
                  onChanged: (value) {
                    settings.toggleDayNight(value);
                  },
                ),
              ),
              SizedBox(height: 20),
              _buildSettingCard(
                context,
                title: settings.selectedLanguage == 'Français' ? 'Langues' : 'Languages',
                icon: Icons.language,
                onTap: _showLanguageDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
      BuildContext context, {
        required String title,
        IconData? icon,
        Widget? trailing,
        void Function()? onTap,
      }) {
    var settings = Provider.of<SettingsProvider>(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: icon != null
            ? Icon(
          icon,
          size: 40,
          color: settings.isDayNight ? Colors.white : Colors.black,
        )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: settings.fontSize,
            color: settings.isDayNight ? Colors.white : Colors.black,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
