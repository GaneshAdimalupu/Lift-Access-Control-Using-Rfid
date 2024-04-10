import 'package:Elivatme/Admin/Screens/Dashboard/dashboard_screen.dart';
import 'package:Elivatme/Users/Screens/Signup/components/or_divider.dart';
import 'package:Elivatme/Users/Screens/Signup/components/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:Elivatme/services/authentication_service.dart'; // Import your authentication service


class SocalSignUp extends StatelessWidget {
  const SocalSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authService = AuthenticationService();

    void signInWithGoogle(BuildContext context) async {
      final user = await authService.signInWithGoogle(context);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()), // Navigate to main screen
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
                signInWithGoogle(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
