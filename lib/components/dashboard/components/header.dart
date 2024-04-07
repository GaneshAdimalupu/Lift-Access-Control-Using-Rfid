import 'package:Elivatme/Screens/My%20Profile/user_login_details.dart';
import 'package:Elivatme/components/dashboard/controller/menu_app_controller.dart';
import 'package:Elivatme/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('app_users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?; // Specify the type as Map<String, dynamic>

        final profileImageUrl = userData?['profileImageUrl'] as String? ?? ''; // Ensure profileImageUrl is of type String

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailsPage(user: user),
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : AssetImage('assets/default_profile_image.png') as ImageProvider, // Ensure correct type
                ),
              ),
              if (!Responsive.isMobile(context))
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
            ],
          ),
        );
      },
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