import 'package:Elivatme/Screens/Dashboard/Tabs/lift_usage_log.dart';
import 'package:Elivatme/Screens/Dashboard/Tabs/users.dart';
import 'package:Elivatme/Screens/My%20Profile/profile_widget.dart';
import 'package:Elivatme/Screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Elivatme/components/dashboard/controller/menu_app_controller.dart';
import 'package:Elivatme/Screens/Dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Initialize Firebase
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void _handleProfileClicked(BuildContext context) {
    // Add your logic here for when the profile is clicked
    // For example, you can navigate to the My Profile screen
    Navigator.pushNamed(context, '/My Profile');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lift Access',
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => WelcomeScreen(),
        '/Dash Board': (context) => const DashboardScreen(),
        '/Lift User Profile': (context) => const ProfileScreen(),
        '/Lift Usage Log': (context) => const LiftUsageLogScreen(),
        '/My Profile': (context) => ProfileWidget(
              imagePath: '', // Provide an image path here if needed
              onClicked: () => _handleProfileClicked(
                  context), // Provide the onClicked function
            ),
        // Define other routes here if needed
      },
    );
  }
}
