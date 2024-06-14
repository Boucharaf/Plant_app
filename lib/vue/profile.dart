import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantapp/main1.dart';
import '../settings_provider.dart';

class Profile extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              settings.selectedLanguage == 'Français' ? 'Profil' : 'Profile',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFF569C3B),
          ),
          backgroundColor: settings.isDayNight ? Color(0XFF2A303D) : Color(0XFFE8F2E7),
          body: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(double.infinity, 300),
                  painter: DiagonalPainter(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 43,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: settings.isDayNight? Color(0xFF463F32): Color(0xFFFFFFFF),
                            hintText: settings.selectedLanguage == 'Français'
                                ? 'Entrez votre nom'
                                : 'Enter your last name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: settings.isDayNight? Color(0xFF463F32): Color(0xFFFFFFFF),
                            hintText: settings.selectedLanguage == 'Français'
                                ? 'Entrez votre prénom'
                                : 'Enter your first name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF569C3B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyApp1(
                                name: nameController.text,
                                firstName: firstNameController.text,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          settings.selectedLanguage == 'Français' ? 'Valider' : 'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ),
                    ],
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

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF569C3B)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 90)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
