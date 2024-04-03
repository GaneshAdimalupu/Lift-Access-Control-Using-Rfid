import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Elivatme/Screens/Dashboard/home.dart';
import 'package:Elivatme/Screens/Dashboard/lift_usage_log.dart';
import 'package:Elivatme/Screens/Main%20Screen/MainScreen.dart';
import 'package:Elivatme/Screens/Main%20Screen/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Elivatme/Screens/My_Profile/page/profile_page.dart';
import 'package:Elivatme/Screens/My_Profile/utils/user_preferences.dart';
import 'package:Elivatme/components/dashboard/controller/menu_app_controller.dart';
import 'package:Elivatme/Screens/Dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart'; // Import animated_theme_switcher package
import 'constants.dart'; // Import your constants file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Initialize Firebase
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) =>
              ThemeNotifier(), // Provide the ThemeNotifier here
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        // Remove the ChangeNotifierProvider for ThemeNotifier
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return ThemeProvider(
            initTheme: MyThemes.lightTheme, // Set the initial theme
            child: Builder(
              builder: (context) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Lift Access',
                  theme:
                      MyThemes.lightTheme, // Set the light theme from MyThemes
                  darkTheme:
                      MyThemes.darkTheme, // Set the dark theme from MyThemes
                  themeMode: themeNotifier
                      .getThemeMode(), // Get the theme mode from the theme notifier
                  initialRoute: '/', // Set the initial route to '/'
                  routes: {
                    // '/': (context) => const WelcomeScreen(),
                    // '/login': (context) => const LoginScreen(),
                    // '/main': (context) => const MainScreen(),
                    '/': (context) => const MainScreen(),

                    '/dashboard': (context) => const DashboardScreen(),
                    '/settings': (context) => const SettingsScreen(),
                    '/profile': (context) => const ProfilePage(),
                    '/usage': (context) => const LiftUsageLogScreen(),
                    '/graph': (context) => const SmoothScreen(),

                    //'/editprofile': (context) =>  EditProfilePage(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeNotifier() {
    _themeMode = ThemeMode.system; // Start with system theme mode
  }

  ThemeMode getThemeMode() => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
