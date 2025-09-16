// import 'package:flutter/material.dart';
//
// import '../../DashBoard/Model/EmployeesLIstModel.dart';
//
// class ListWidget extends StatelessWidget {
//   final List<Data> employeelist;
//
//   const ListWidget({super.key, required this.employeelist});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // const Padding(
//         //   padding: EdgeInsets.all(8.0),
//         //   child: Text(
//         //     "Employee List",
//         //     style: TextStyle(
//         //       fontSize: 18,
//         //       fontWeight: FontWeight.bold,
//         //       color: Colors.black87,
//         //     ),
//         //   ),
//         // ),
//         Expanded(
//           child: ListView.separated(
//             itemCount: employeelist.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 2),
//             itemBuilder: (context, index) {
//               final employee = employeelist[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.green.shade400,
//                   child: Text(
//                     employee.name != null && employee.name!.isNotEmpty
//                         ? employee.name![0].toUpperCase()
//                         : "?",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 title: Text(employee.name ?? "No Name"),
//                 subtitle: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("ID: ${employee.employeeId ?? "N/A"}"),
//                     Text(
//                       employee.email ?? "No Email",
//                       style: TextStyle(
//                         color:
//                             (employee.email != null &&
//                                 employee.email!.isNotEmpty)
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 onTap: () {
//                   debugPrint(
//                     "Tapped on ${employee.name} (${employee.employeeId})",
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import '../../DashBoard/Model/EmployeesLIstModel.dart';
//
// class ListWidget extends StatelessWidget {
//   final List<Data> employeelist;
//
//   const ListWidget({super.key, required this.employeelist});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: ListView.separated(
//             itemCount: employeelist.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 2),
//             itemBuilder: (context, index) {
//               final employee = employeelist[index];
//
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.green.shade400,
//                   child: Text(
//                     employee.name != null && employee.name!.isNotEmpty
//                         ? employee.name![0].toUpperCase()
//                         : "?",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 title: Text(employee.name ?? "No Name"),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("ID: ${employee.employeeId ?? "N/A"}"),
//                     Text(
//                       employee.email ?? "No Email",
//                       style: TextStyle(
//                         color:
//                             (employee.email != null &&
//                                 employee.email!.isNotEmpty)
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 /// 🔥 3 Options - Default, Edit, Delete
//                 trailing: PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == "default") {
//                       debugPrint(
//                         "Default option selected for ${employee.name}",
//                       );
//                       // Apana details screen ku navigate kari paribe
//                     } else if (value == "edit") {
//                       debugPrint("Edit option selected for ${employee.name}");
//                       // Apana Add/Edit screen ku navigate kari paribe
//                     } else if (value == "delete") {
//                       debugPrint("Delete option selected for ${employee.name}");
//                       // Apana delete API call kari paribe
//                     }
//                   },
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: "default",
//                       child: Row(
//                         children: [
//                           Icon(Icons.visibility, color: Colors.blue),
//                           SizedBox(width: 8),
//                           Text("View Details"),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuItem(
//                       value: "edit",
//                       child: Row(
//                         children: [
//                           Icon(Icons.edit, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text("Edit Employee"),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuItem(
//                       value: "delete",
//                       child: Row(
//                         children: [
//                           Icon(Icons.delete, color: Colors.red),
//                           SizedBox(width: 8),
//                           Text("Delete Employee"),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../DashBoard/Model/EmployeesLIstModel.dart';
import 'EmployeeProfileScreen.dart';

class ListWidget extends StatelessWidget {
  final List<Data> employeelist;

  const ListWidget({super.key, required this.employeelist});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: employeelist.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final employee = employeelist[index];

              return ListTile(
                onTap: () {
                  // if (employee.employeeId != null) {
                  //   Get.to(
                  //     () => EmployeeProfileScreen(
                  //       employeeId: int.parse(employee.employeeId!),
                  //     ),
                  //   );
                  // }
                  // onTap: () {
                  /// ✅ Navigate to EmployeeProfileScreen with dynamic ID
                  if (employee.employeeId != null) {
                    Get.to(
                      () => EmployeeProfileScreen(
                        employeeId:
                            int.tryParse(employee.employeeId.toString()) ?? 0,
                      ),
                    );
                  } else {
                    Get.snackbar("Error", "Employee ID not available");
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  child: Text(
                    employee.name != null && employee.name!.isNotEmpty
                        ? employee.name![0].toUpperCase()
                        : "?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(employee.name ?? "No Name"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID : ${employee.id ?? "N/A"}"),
                    Text(
                      employee.email ?? "N/A",
                      style: TextStyle(
                        color:
                            (employee.email != null &&
                                employee.email!.isNotEmpty)
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // trailing:  PopupMenuButton<String>(onSelected: (value){
                //   if()
                //
                // }, itemBuilder: (BuildContext context) {  },),
              );
            },
          ),
        ),
      ],
    );
  }
}
