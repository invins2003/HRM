// import 'package:flutter/material.dart';
//
// class EmployeeScreen extends StatefulWidget {
//   const EmployeeScreen({super.key});
//
//   @override
//   State<EmployeeScreen> createState() => _EmployeeScreenState();
// }
//
// class _EmployeeScreenState extends State<EmployeeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Icon(Icons.search, color: Colors.black54),
//                         ),
//                         const SizedBox(width: 5),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 8),
//                           child: VerticalDivider(
//                             width: 5,
//                             color: Colors.black26,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: TextFormField(
//                             decoration: const InputDecoration(
//                               hintText: "Search Employee",
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               isCollapsed: true,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     onTap: () {},
//                     child: const Icon(Icons.filter_list, color: Colors.black54),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListView.builder(
//             itemBuilder: (context, index) {
//               return Text("Hello");
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../Controller/EmployeeListController.dart';
//
// class EmployeeScreen extends StatefulWidget {
//   const EmployeeScreen({super.key});
//
//   @override
//   State<EmployeeScreen> createState() => _EmployeeScreenState();
// }
//
// class _EmployeeScreenState extends State<EmployeeScreen> {
//   final EmployeeListController controller = Get.put(
//     EmployeeListController(employeeListRepo: Get.find()),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       controller.listtController();
//     });
//   }
//
//   // Dummy Employee List
//   final List<Map<String, dynamic>> employees = [
//     {
//       "name": "Akash Mahapatra",
//       "EmployeeId": 12213456,
//       "Registered": "Registered",
//     },
//     {"name": "Kunal", "EmployeeId": 123234456, "Registered": "Not Registered"},
//     {"name": "Abhisek", "EmployeeId": 12345236, "Registered": "Registered"},
//     {"name": "Dipankar", "EmployeeId": 123456, "Registered": "Not Registered"},
//     {"name": "Shonthosh", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "aakku", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "ambit", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "Prakash", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "jaye", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "jayshree", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "ankita", "EmployeeId": 123457, "Registered": "Registered"},
//     {"name": "subhra", "EmployeeId": 123457, "Registered": "Registered"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//
//           /// Search + Filter Row
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Icon(Icons.search, color: Colors.black54),
//                         ),
//                         const SizedBox(width: 5),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 8),
//                           child: VerticalDivider(
//                             width: 5,
//                             color: Colors.black26,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: TextFormField(
//                             decoration: const InputDecoration(
//                               hintText: "Search Employee",
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               isCollapsed: true,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       debugPrint("Filter tapped");
//                     },
//                     child: const Icon(Icons.filter_list, color: Colors.black54),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Employee List
//           Expanded(
//             child: ListView.builder(
//               itemCount: employees.length,
//               itemBuilder: (context, index) {
//                 final employee = employees[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.green.shade400,
//                     child: Text(
//                       employee["name"][0], // first letter
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   title: Text(employee["name"]),
//                   subtitle: Text("ID: ${employee["EmployeeId"]}"),
//                   // trailing: Text(
//                   //   employee["Registered"],
//                   //   style: TextStyle(
//                   //     color: employee["Registered"] == "Registered"
//                   //         ? Colors.green
//                   //         : Colors.red,
//                   //     fontWeight: FontWeight.bold,
//                   //   ),
//                   // ),
//                   onTap: () {
//                     debugPrint("Tapped on ${employee["name"]}");
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../Controller/EmployeeListController/EmployeeListController.dart';
// import 'EmployeeLIstWidget.dart';
//
// class EmployeeScreen extends StatefulWidget {
//   const EmployeeScreen({super.key});
//
//   @override
//   State<EmployeeScreen> createState() => _EmployeeScreenState();
// }
//
// class _EmployeeScreenState extends State<EmployeeScreen> {
//   final EmployeeListController controller = Get.put(
//     EmployeeListController(employeeListRepo: Get.find()),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       controller.listtController();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//
//           /// Search + Filter Row
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Icon(Icons.search, color: Colors.black54),
//                         ),
//                         const SizedBox(width: 5),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 8),
//                           child: VerticalDivider(
//                             width: 5,
//                             color: Colors.black26,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         const Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               hintText: "Search Employee",
//                               border: InputBorder.none,
//                               isCollapsed: true,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       debugPrint("Filter tapped");
//                     },
//                     child: const Icon(Icons.filter_list, color: Colors.black54),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Employee List (with controller)
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (controller.employeelisttt.isEmpty) {
//                 return const Center(child: Text("No Employees Found"));
//               }
//               return ListWidget(employeelist: controller.employeelisttt);
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/EmployeeListController/EmployeeListController.dart';
import 'EmployeeLIstWidget.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeListController controller = Get.put(
    EmployeeListController(employeeListRepo: Get.find()),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.listtController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// Search + Filter Row
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.search, color: Colors.black54),
                        ),
                        const SizedBox(width: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: VerticalDivider(
                            width: 5,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(width: 5),

                        /// TextField for search
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              controller.filterEmployees(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Employee",
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Filter tapped");
                    },
                    child: const Icon(Icons.filter_list, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredList.isEmpty) {
                return const Center(child: Text("No Employees Found"));
              }
              return ListWidget(employeelist: controller.filteredList);
            }),
          ),
        ],
      ),
    );
  }
}
