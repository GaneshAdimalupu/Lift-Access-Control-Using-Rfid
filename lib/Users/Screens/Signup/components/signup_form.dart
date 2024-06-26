import 'package:Elivatme/Users/Screens/components/already_have_an_account_acheck.dart';
import 'package:Elivatme/Users/Screens/Dashboard/dashboard_screen.dart';
import 'package:Elivatme/Users/Screens/Login/login_screen.dart';
import 'package:Elivatme/Users/Services/authentication_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthenticationService _authService = AuthenticationService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late String fullName;
  late num collegeID;

  String? emailError;
  String? passwordError;
  String? signUpError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (value) => email = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!isValidEmail(value)) {
                  signUpError = 'Enter a valid email address';
                  return signUpError;
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                hintText: "Your email",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (value) => fullName = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                hintText: "Your full name",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (value) => collegeID = int.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your college ID';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.school,
                  color: kPrimaryColor,
                ),
                hintText: "Your college ID",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              onSaved: (value) => password = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return passwordError;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                hintText: "Your password",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value != '111') {
                  return 'Please enter User Key';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.school,
                  color: kPrimaryColor,
                ),
                hintText: "User Key",
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState!.save();

                    final user = await _authService.signUpWithEmailAndPassword(
                      email,
                      password,
                      fullName,
                      collegeID,
                    );
                    if (user != null) {
                      await saveUserDataToFirestore(
                          user.uid, email, fullName, collegeID);
                      await saveUserDataToRealtimeDB(
                        email,
                        fullName,
                        collegeID,
                        user.uid,
                      );
                      Fluttertoast.showToast(
                          msg: "User is Successfully Created");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DashboardScreen('/Users')),
                      );
                    } else {
                      Fluttertoast.showToast(msg: "Invalid credentials");
                    }
                  }
                },
                child: Text("Sign Up".toUpperCase()),
              ),
              ElevatedButton(
                onPressed: () {
                  final Uri _whatsappLaunchUri =
                      Uri.parse('https://wa.me/916303205936');
                  launch(_whatsappLaunchUri.toString());
                  // Your "Get Key" button logic here
                },
                child: Text("Get Key"),
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen('/Users');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    // You can implement your email format validation logic here
    // For a simple check, we're using a regular expression
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailRegex).hasMatch(email);
  }

  Future<void> saveUserDataToFirestore(
    String docId,
    String email,
    String fullName,
    num collegeID,
  ) async {
    try {
      // Set document ID equal to email
      final documentID = email;

      // Default role
      final defaultRole = 'user';

      // Save data to 'app_users' collection
      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(documentID)
          .set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'uid': docId,
        'role': defaultRole, // Set default role here
      });

      // Save the same data to 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(documentID).set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'uid': docId,
        'role': defaultRole, // Set default role here
        'liftUsage': [], // Initialize lift usage as an empty list
      });
    } catch (error) {
      print('Error saving user data to Firestore: $error');
    }
  }

  Future<void> saveUserDataToRealtimeDB(
    String email,
    String fullName,
    num collegeID,
    String docId,
  ) async {
    try {
      // Sanitize email for Realtime Database key
      String sanitizedEmail = email.replaceAll('.', '_');

      // Save data to 'app_users' node
      DatabaseReference appUserRef = FirebaseDatabase.instance
          .reference()
          .child('app_users')
          .child(sanitizedEmail);

      await appUserRef.set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'uid': docId,
        'role': 'user', // Set default role here
        'liftUsage': [], // Initialize lift usage as an empty list
      });

      // Save the same data to 'users' node
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(sanitizedEmail);

      await userRef.set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'uid': docId,
        'role': 'user', // Set default role here
        'liftUsage': [], // Initialize lift usage as an empty list
      });

      print('User data saved to Realtime Database successfully');
    } catch (error) {
      print('Error saving user data to Realtime Database: $error');
    }
  }
}
