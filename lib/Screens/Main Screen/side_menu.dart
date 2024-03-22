import 'package:flutter/material.dart';
import 'package:flutter_auth/dashboard/models/lift_usage_log.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_auth/dashboard/models/profile_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          // Inside SideMenu class
          DrawerListTile(
            title: "Lift Usage Log",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   const LiftUsageLogScreen(),
                ),
              );
            },
          ),

          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              // Navigate to ProfileScreen when "Profile" item is pressed
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
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
        colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 0, 0, 0), BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
