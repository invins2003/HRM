// import 'package:flutter/material.dart';
//
// class EmployeeItem extends StatelessWidget {
//   final String name;
//   final int employeeId;
//   final String registered;
//
//   const EmployeeItem({
//     super.key,
//     required this.name,
//     required this.employeeId,
//     required this.registered,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.green.shade400,
//         child: Text(name[0], style: const TextStyle(color: Colors.white)),
//       ),
//       title: Text(name),
//       subtitle: Text("ID: $employeeId"),
//       trailing: Text(
//         registered,
//         style: TextStyle(
//           color: registered == "Registered" ? Colors.green : Colors.red,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: () {
//         debugPrint("Tapped on $name ($employeeId)");
//       },
//     );
//   }
// }
