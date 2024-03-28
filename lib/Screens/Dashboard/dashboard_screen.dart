import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Dashboard/lift_usage_log.dart';
import 'package:flutter_auth/Screens/Dashboard/profile_screen.dart';
import 'package:flutter_auth/responsive.dart';
import '../../../constants.dart';
import '../../components/dashboard/components/header.dart';
import 'lift_usage_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (_currentIndex != 1) // Render the header only if not in the "Home" tab
            const Header(),
          const SizedBox(height: defaultPadding),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                const ProfileScreen(),
                const LiftUsageChart(),
                const LiftUsageLogScreen()
              ],
            ),
          ),
          if (Responsive.isMobile(context))
            BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_chart_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.data_usage),
                  label: 'Usage Log',
                ),
              ],
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
            ),
        ],
      ),
    );
  }
}
