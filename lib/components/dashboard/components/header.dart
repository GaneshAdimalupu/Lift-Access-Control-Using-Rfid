import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/My_Profile/page/profile_page.dart';
import 'package:flutter_auth/components/dashboard/controller/menu_app_controller.dart';
import 'package:flutter_auth/responsive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().toggleDrawer,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SearchField(),
              const SizedBox(
                  width:
                      10), // Add some spacing between SearchField and ProfileCard
              ProfileCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      child: Row(
        children: [
          Hero(
            tag: 'profilePic', // Unique tag for the Hero animation
            child: Icon(
              LineAwesomeIcons
                  .alternate_sign_in, // Use LineAwesomeIcons.search as the icon
            ),
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8), // Adjusted horizontal padding
              child: Text("Angelina Jolie"),
            ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement your search logic here
        // For now, just print a message
        print('Perform search');
      },
      child: Icon(
        LineAwesomeIcons.search, // Use LineAwesomeIcons.search as the icon
      ),
    );
  }
}
