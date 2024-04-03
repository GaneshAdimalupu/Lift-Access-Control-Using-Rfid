import 'package:Elivatme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'settings.dart'; // Assuming you have the SettingsScreen widget in a separate file

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: MyThemes.lightTheme, // Use your light theme
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            DrawerListTile(
              title: "Logout",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                _handleLogout(context); // Call the logout handler method

              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Brightness themeBrightness = Theme.of(context).brightness;
    Color textColor = themeBrightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 255, 255, 255);

    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        height: 16,
        color: textColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
 void _handleLogout(BuildContext context) {
    // Add your logout logic here
    // For example, you can navigate to the login screen:
    Navigator.pushReplacementNamed(context, '/login');
  }