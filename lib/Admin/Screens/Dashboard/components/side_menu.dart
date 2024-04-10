import 'package:Elivatme/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Elivatme/Admin/Screens/Lift%20Access/elivator_use.dart';
import '../settings.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1B0E41),
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo_light.png"),
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              ),
            ),
            DrawerListTile(
              title: "Use Lift",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ElevatorPage(
                    numberOfFloors: 5,
                  ),
                ),
              ),
            ),
            DrawerListTile(
              title: "Logout",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}

void _handleLogout(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => WelcomeScreen(),
    ),
  );
}
