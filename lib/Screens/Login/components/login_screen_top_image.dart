// //login_screen_top_image.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../constants.dart';

// class LoginScreenTopImage extends StatelessWidget {
//   const LoginScreenTopImage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text(
//           "LOGIN",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: defaultPadding * 2),
//         Row(
//           children: [
//             const Spacer(),
//             Expanded(
//               flex: 8,
//               child: SvgPicture.asset("assets/icons/login.svg"),
//             ),
//             const Spacer(),
//           ],
//         ),
//         const SizedBox(height: defaultPadding * 2),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increase font size for emphasis
            color: Color.fromARGB(255, 201, 112, 164), // Custom text color
          ),
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.all(16), // Add padding for the SVG image
                decoration: BoxDecoration(
                  color: Colors.white, // Custom background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Shadow offset
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: 200, // Adjust SVG image size
                  width: 200,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
