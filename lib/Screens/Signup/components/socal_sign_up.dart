import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Main%20Screen/MainScreen.dart';
import 'package:flutter_auth/services/authentication_service.dart'; // Import your authentication service

import '../../../screens/Signup/components/or_divider.dart';
import '../../../screens/Signup/components/social_icon.dart';

class SocalSignUp extends StatelessWidget {
  const SocalSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authService = AuthenticationService();

    void _signInWithGoogle(BuildContext context) async {
      final user = await _authService.signInWithGoogle(context);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()), // Navigate to main screen
        );
      }
    }

    return Column(
      children: [
        const OrDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocalIcon(
              iconSrc: "assets/icons/facebook.svg",
              press: () {
                // Handle Facebook sign-in
              },
            ),
            SocalIcon(
              iconSrc: "assets/icons/twitter.svg",
              press: () {
                // Handle Twitter sign-in
              },
            ),
            SocalIcon(
              iconSrc: "assets/icons/google-plus.svg",
              press: () {
                // Handle Google sign-in
                _signInWithGoogle(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
