// signup_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/services/authentication_service.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import 'package:flutter_auth/auth/auth_exception.dart';

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
                return 'Enter a valid email address';
              }
              return emailError;
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

                try {
                  final user = await _authService.signUpWithEmailAndPassword(email, password);
                  if (user != null) {
                    print("Sign up successful: ${user.email}");
                    // TODO: Navigate or update UI accordingly
                  }
                } on AuthException catch (e) {
                  handleAuthException(e);
                  // TODO: Show an error message to the user
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

  void handleAuthException(AuthException e) {
    switch (e.code) {
      case 'invalid-email':
        setState(() {
          emailError = 'Invalid email address';
          passwordError = null;
        });
        break;
      case 'email-already-in-use':
        setState(() {
          emailError = 'Email already in use';
          passwordError = null;
        });
        break;
      // Add more cases as needed
      default:
      setState(() {
        emailError = 'An error occurred: ${e.message}';
        passwordError = null;
      });
        break;
    }
  }

  bool isValidEmail(String email) {
    // You can implement your email format validation logic here
    // For a simple check, we're using a regular expression
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailRegex).hasMatch(email);
  }
}
