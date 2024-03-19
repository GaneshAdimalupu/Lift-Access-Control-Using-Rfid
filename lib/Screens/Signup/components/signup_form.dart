// signup_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthenticationService _authService = AuthenticationService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email;
  late String password;

  String? emailError;
  String? passwordError;
  String? signUpError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
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
              hintText: "Your email",
              errorText: emailError,
              prefixIcon: const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
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
                hintText: "Your password",
                errorText: passwordError,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState!.save();

                final user = await _authService.signUpWithEmailAndPassword(
                    email, password);
                if (user != null) {
                  Fluttertoast.showToast(msg: "User is Successfully Created");
                  // TODO: Navigate or update UI accordingly
                }
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              // You can navigate to the login screen or perform any other action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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
}