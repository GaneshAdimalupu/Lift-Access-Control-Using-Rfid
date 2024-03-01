// login_form.dart
import 'package:flutter/material.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'package:flutter_auth/services/authentication_service.dart';
import 'package:flutter_auth/auth/auth_exception.dart'; // Import the AuthException class

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
                } else if (value.length < 8) {
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
                  final userCredential = await _authService.signInWithEmailAndPassword(email, password);
                  if (userCredential.user != null) {
                    print("Login successful: ${userCredential.user!.email}");
                    // TODO: Navigate or update UI accordingly
                  }
                } on AuthException catch (e) {
                  handleAuthException(e);
                  // TODO: Show an error message to the user
                }
              }
            },
            child: Text("Login".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
      case 'user-not-found':
        setState(() {
          emailError = 'User not found';
          passwordError = null;
        });
        break;
      case 'wrong-password':
        setState(() {
          passwordError = 'Incorrect password';
          emailError = null;
        });
        break;
      // Add more cases as needed
      default:
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
