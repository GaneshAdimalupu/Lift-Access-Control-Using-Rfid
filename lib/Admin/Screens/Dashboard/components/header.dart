import 'package:Elivatme/Admin/Screens/My%20Profile/user_login_details.dart';
import 'package:Elivatme/Admin/Screens/Dashboard/components/controller/menu_app_controller.dart';
import 'package:Elivatme/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
}class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('app_users').doc(user!.email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;

        // Extract profileImageUrl safely
        final profileImageUrl = userData?['profileImageUrl'] as String?;

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
                  // Use profileImageUrl safely
                  backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl) as ImageProvider
                      : AssetImage('assets/default_profile.jpg'),
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


