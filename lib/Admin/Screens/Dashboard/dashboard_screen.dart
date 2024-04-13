import 'package:Elivatme/Admin/Screens/Side%20Menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:Elivatme/Admin/Screens/Dashboard/Tabs/lift_usage_log.dart';
import 'package:Elivatme/Admin/Screens/Dashboard/Tabs/users.dart';
import 'package:Elivatme/responsive.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import 'Tabs/home.dart';
import 'components/controller/menu_app_controller.dart';

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
        duration: const Duration(
            milliseconds: 300), // Adjust transition duration as needed
        curve: Curves.easeInOut, // Apply a custom curve for smoother animation
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      backgroundColor: const Color(0xFF1B0E41), // Set background color here
      body: SafeArea(
        child: Column(
          children: [
            // if (_currentIndex != 1) // Render the header only if not in the "Home" tab
            //   const Header(),
            const SizedBox(height: defaultPadding),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [
                  ProfileScreen(),
                  SmoothScreen(),
                  LiftUsageLogScreen()
                ],
                // Customize page transition
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
              ),
            ),
            if (Responsive.isMobile(context))
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color:
                      Colors.transparent, // Set background color to transparent
                  border: Border.all(
                      color: Colors
                          .transparent), // Set border color to transparent
                ),
                child: BottomNavigationBar(
                  backgroundColor:
                      Colors.transparent, // Set background color to transparent
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
                  selectedItemColor: Color.fromARGB(
                      255, 22, 81, 230), // Set selected item color
                  unselectedItemColor:
                      Colors.white, // Set unselected item color
                ),
              ),
          ],
        ),
      ),
    );
  }
}
