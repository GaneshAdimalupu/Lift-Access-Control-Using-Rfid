import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Login/login_screen.dart';

class WelcomeBtn extends StatefulWidget {
  const WelcomeBtn({super.key});

  @override
  _WelcomeBtnState createState() => _WelcomeBtnState();
}

class _WelcomeBtnState extends State<WelcomeBtn> {
  late SharedPreferences _prefs;
  bool _hasSeenWelcome = false;

  @override
  void initState() {
    super.initState();
    _checkWelcomeStatus();
  }

  Future<void> _checkWelcomeStatus() async {
    _prefs = await SharedPreferences.getInstance();
    _hasSeenWelcome = _prefs.getBool('hasSeenWelcome') ?? false;
    if (_hasSeenWelcome) {
      // If user has already seen welcome, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  void _markWelcomeSeen() async {
    // Mark welcome page as seen
    await _prefs.setBool('hasSeenWelcome', true);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _markWelcomeSeen();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      child: Text(
        "Welcome".toUpperCase(),
      ),
    );
  }
}
