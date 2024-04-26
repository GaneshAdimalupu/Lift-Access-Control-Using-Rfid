// import 'package:Elivatme/Use%20Lift/service/database.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:random_string/random_string.dart';
// class Employe extends StatefulWidget {
//   const Employe({super.key});

//   @override
//   State<Employe> createState() => _EmployeState();
// }

// class _EmployeState extends State<Employe> {
//   TextEditingController namecontroller = new TextEditingController();
//   TextEditingController agecontroller = new TextEditingController();
//   TextEditingController locationcontroller = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Row(
//         children: [
//           Text(
//             "Flutter",
//             style: TextStyle(
//                 color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             "Firebase",
//             style: TextStyle(
//                 color: Colors.orange,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold),
//           ),
//         ],
//       )),
//       body: Container(
//         margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
//         child: Column(
//           children: [
//             const Text(
//               "Name",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                   border: Border.all(),
//                   borderRadius: BorderRadius.circular(10)),
//               child: const TextField(
//                 decoration: InputDecoration(border: InputBorder.none),
//               ),
//             ),
//             const Text(
//               "Age",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                   border: Border.all(),
//                   borderRadius: BorderRadius.circular(10)),
//               child: const TextField(
//                 decoration: InputDecoration(border: InputBorder.none),
//               ),
//             ),
//             const Text(
//               "Location",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                   border: Border.all(),
//                   borderRadius: BorderRadius.circular(10)),
//               child: const TextField(
//                 decoration: InputDecoration(border: InputBorder.none),
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   String Id = randomAlphaNumeric(10);
//                   Map<String, dynamic> employeeInfoMap = {
//                     "Name": namecontroller.text,
//                     "Id": Id,
//                     "Age": agecontroller.text,
//                     "Location": locationcontroller.text
//                   };
//                   await DatabaseMethods()
//                       .addEmployeeDetails(employeeInfoMap, Id).then((value) {
//                         Fluttertoast.showToast(
//         msg: "Employe details had been uploded succesfully",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );});
//                 },
//                 child: Text(
//                   "Add",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
