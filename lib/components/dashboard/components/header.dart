import 'package:Elivatme/Screens/My_Profile/page/profile_page.dart';
import 'package:Elivatme/components/dashboard/controller/menu_app_controller.dart';
import 'package:Elivatme/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1B0E41), // Set background color here
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: context.read<MenuAppController>().toggleDrawer,
            ),
          if (!Responsive.isMobile(context))
            Text(
              "Dashboard",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SearchField(),
                SizedBox(
                  width: 10,
                ), // Add some spacing between SearchField and ProfileCard
                ProfileCard(),
              ],
            ),
          ),
        ],
      ),
    );
    
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      },
      child: Row(
        children: [
          Hero(
            tag: 'profilePic', // Unique tag for the Hero animation
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: user != null
                  ? NetworkImage(
                      // Use the user's profile picture URL from Firestore
                      'https://console.firebase.google.com/u/1/project/lift-access-control/storage/lift-access-control.appspot.com/files/${user.uid}.jpg',
                    )
                  : null,
              child: user == null
                  ? const Icon(
                      LineAwesomeIcons.user,
                      color: Color(0xFF1B0E41),
                    )
                  : null,
            ),
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8), // Adjusted horizontal padding
              child: Text(
                "Angelina Jolie",
                style: TextStyle(color: Colors.white),
              ),
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
        color: Colors.white,
      ),
    );
  }
}
