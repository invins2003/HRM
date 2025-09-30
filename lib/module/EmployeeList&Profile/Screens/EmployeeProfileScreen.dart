import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeProfileController/EmployeeProfileController.dart';
//
// class EmployeeProfileScreen extends StatelessWidget {
//   final int employeeId;
//
//   const EmployeeProfileScreen({super.key, required this.employeeId});
//
//   @override
//   Widget build(BuildContext context) {
//     // Inject Controller with Repo (Repo already registered in Get.put / Get.lazyPut)
//     final EmployeeProfileController controller = Get.put(
//       EmployeeProfileController(employeeProfileRepo: Get.find()),
//     );
//
//     // Call API when screen opens
//     controller.profileController(employeeId);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Employee Profile",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//         automaticallyImplyLeading: false,
//       ),
//       body: Obx(() {
//         if (controller.isloading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         // If no data found
//         if (controller.Profiledata.value.data == null) {
//           return const Center(
//             child: Text(
//               "No Profile Data Found",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           );
//         }
//         final profile = controller.Profiledata.value;
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Profile Avatar
//                   Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.green.shade400,
//                       child: const Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   /// Employee ID
//                   Text(
//                     "Employee ID: ${profile.data?.id ?? "--"}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//
//                   /// Name
//                   Text(
//                     "Name: ${profile.data?.name ?? "--"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//
//                   /// Email
//                   Text(
//                     "Email: ${profile.data?.email ?? "--"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//
//                   /// Mobile
//                   Text(
//                     "Mobile: ${profile.data?.phone ?? "--"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//
//                   /// Department
//                   Text(
//                     "Department: ${profile.data?.department ?? "--"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//
//                   /// Designation
//                   Text(
//                     "Designation: ${profile.data?.designation ?? "--"}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeProfileController/EmployeeProfileController.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final int employeeId;

  const EmployeeProfileScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final EmployeeProfileController controller = Get.put(
      EmployeeProfileController(employeeProfileRepo: Get.find()),
    );

    // API call
    controller.profileController(employeeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Employee Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.Profiledata.value.data == null) {
          return const Center(
            child: Text(
              "No Profile Data Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        final profile = controller.Profiledata.value.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// Avatar
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green.shade400,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Details in ListTile format
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.green),
                  title: const Text("Employee ID"),
                  subtitle: Text(profile?.id?.toString() ?? "--"), // ✅ FIXED
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text("Name"),
                  subtitle: Text(profile?.name?.toString() ?? "--"), // ✅ SAFE
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: const Text("Email"),
                  subtitle: Text(profile?.email?.toString() ?? "--"),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text("Mobile"),
                  subtitle: Text(profile?.phone?.toString() ?? "--"),
                ),
                ListTile(
                  leading: const Icon(Icons.account_tree, color: Colors.green),
                  title: const Text("Department"),
                  subtitle: Text(profile?.department?.toString() ?? "--"),
                ),
                ListTile(
                  leading: const Icon(Icons.work, color: Colors.green),
                  title: const Text("Designation"),
                  subtitle: Text(profile?.designation?.toString() ?? "--"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
