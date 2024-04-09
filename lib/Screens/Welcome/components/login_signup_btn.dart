import 'package:Elivatme/Screens/Lift%20Access/elivator_use.dart';
import 'package:flutter/material.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';
import '../../Dashboard/dashboard_screen.dart';

class WelcomeBtn extends StatefulWidget {
  const WelcomeBtn({Key? key}) : super(key: key);

  @override
  _WelcomeBtnState createState() => _WelcomeBtnState();
}

class _WelcomeBtnState extends State<WelcomeBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: AnimatedButton(
            text: 'User',
            onClicked: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen()
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: AnimatedButton(
            text: 'Admin',
            onClicked: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: AnimatedButton(
            text: 'Guests',
            onClicked: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ElevatorPage(numberOfFloors: 5,),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onClicked;

  const AnimatedButton({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
        ),
        onPressed: widget.onClicked,
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          child: Text(widget.text),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward();
  }
}
