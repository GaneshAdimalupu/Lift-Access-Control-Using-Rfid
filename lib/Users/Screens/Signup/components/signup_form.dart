import 'package:Elivatme/Users/Screens/components/already_have_an_account_acheck.dart';
import 'package:Elivatme/Users/Screens/Dashboard/dashboard_screen.dart';
import 'package:Elivatme/Users/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:Elivatme/services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                if (value != '111' ) {
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
                  Fluttertoast.showToast(msg: "User is Successfully Created");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen('/Users')),
                  );
                  // TODO: Navigate or update UI accordingly
                } else {
                  Fluttertoast.showToast(msg: "Invalid credentials");
                }
              }
            },
            child: Text("Sign Up".toUpperCase()),
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
      String docId, String email, String fullName, num collegeID) async {
    try {
      // Set document ID equal to college ID
      final documentID = email;

      // Save data to 'app_users' collection
      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(documentID)
          .set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
      });

      // Save the same data to 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(documentID).set({
        'email': email,
        'fullName': fullName,
        'collegeID': collegeID,
        'liftUsage': [], // Initialize lift usage as an empty list
      });
    } catch (error) {
      print('Error saving user data to Firestore: $error');
    }
  }
}
