// login_form.dart
import 'package:Elivatme/Screens/Dashboard/dashboard_screen.dart';
import 'package:Elivatme/Screens/Signup/signup_screen.dart';
import 'package:Elivatme/services/authentication_service.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthenticationService _authService = AuthenticationService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  late String email;
  late String password;

  bool obscurePassword = true;
  bool isLoading = false;

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
            } else if (!_isValidEmail(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Your email",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Adjust padding here
            border: OutlineInputBorder( // Make the container for the text input field visible
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: defaultPadding / 2), // Add spacing between fields
        Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          child: TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: obscurePassword,
            cursorColor: kPrimaryColor,
            onSaved: (value) => password = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Your password",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
                icon: Icon(obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Adjust padding here
              border: OutlineInputBorder( // Make the container for the text input field visible
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
        ),
        SizedBox(height: defaultPadding), // Add spacing between fields
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      isLoading = true;
                    });

                    formKey.currentState!.save();

                    try {
                      final user =
                          await _authService.signInWithEmailAndPassword(email, password);
                      if (user != null) {
                        Fluttertoast.showToast(msg: "Login is Successful");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardScreen()),
                        );
                      } else {
                        Fluttertoast.showToast(msg: "Invalid credentials");
                      }
                    } catch (e) {
                      print("Login Error: $e");
                      Fluttertoast.showToast(
                          msg: "An error occurred during login");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
          child: isLoading
              ? const CircularProgressIndicator()
              : Text("Login".toUpperCase()),
        ),
        SizedBox(height: defaultPadding), // Add spacing between fields
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


  // bool _isValidEmail(String email) {
  //   // You can implement your email format validation logic here
  //   // For a simple check, we're using a regular expression
  //   String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
  //   return RegExp(emailRegex).hasMatch(email);
  // }

  bool _isValidEmail(String email) {
    // Regular expression for basic email format
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';

    // Additional validation logic
    bool isWhitelisted = _isWhitelistedDomain(email);
    bool isBlacklisted = _isBlacklistedDomain(email);
    bool isDisposable = _isDisposableEmail(email); // Optional check

    if (isBlacklisted) {
      return false; // Always invalid if blacklisted
    }

    if (isWhitelisted) {
      return true; // Always valid if whitelisted
    }

    // Basic format check + optional checks (MX record optional)
    return RegExp(emailRegex).hasMatch(email) &&
        // ... optional MX record check
        !isDisposable;
  }

// Method to check if the email domain is whitelisted
  bool _isWhitelistedDomain(String email) {
    // Implement logic to check against whitelisted domains
    // Example:
    List<String> whitelistedDomains = ['example.com', 'whitelisteddomain.com'];
    String domain = email.split('@').last;
    return whitelistedDomains.contains(domain);
  }

// Method to check if the email domain is blacklisted
  bool _isBlacklistedDomain(String email) {
    // Implement logic to check against blacklisted domains
    // Example:
    List<String> blacklistedDomains = ['spamdomain.com', 'blacklisted.com'];
    String domain = email.split('@').last;
    return blacklistedDomains.contains(domain);
  }

// Method to check if the email is from a disposable email address provider
  bool _isDisposableEmail(String email) {
    // Implement logic to check against disposable email address providers
    // Example:
    List<String> disposableProviders = [
      'mailinator.com',
      'guerrillamail.com',
      'disposablemail.com'
    ];
    String domain = email.split('@').last;
    return disposableProviders.contains(domain);
  }
}
