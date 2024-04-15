import 'package:Elivatme/Admin/Screens/Side%20Menu/contact_us.dart';
import 'package:Elivatme/Admin/Screens/Side%20Menu/elivator_use.dart';
import 'package:Elivatme/Admin/Screens/Side%20Menu/maintenance.dart';
import 'package:Elivatme/Admin/Screens/Side%20Menu/settings.dart';
import 'package:Elivatme/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1B0E41),
              const Color(0xFF1B0E41),
              const Color(0xFF0A0620),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF1B0E41),
              ),
              child: Image.asset("assets/images/logo_light.png"),
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/settings.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              ),
            ),
            DrawerListTile(
              title: "Use Elevator",
              svgSrc: "assets/icons/use_elevator.svg",
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
              title: "Maintenance",
              svgSrc: "assets/icons/maintence.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaintenancePage(),
                ),
              ),
            ),
            DrawerListTile(
              title: "Contact Us",
              svgSrc: "assets/icons/contact_us.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactPage(),
                ),
              ),
            ),
            DrawerListTile(
              title: "Logout",
              svgSrc: "assets/icons/logout.svg",
              press: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  _DrawerListTileState createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
        widget.press();
      },
      onTapDown: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.forward();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: ListTile(
          leading: SvgPicture.asset(
            widget.svgSrc,
            height: 16,
            color: Colors.white, // Set the color of the SVG image to white
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
