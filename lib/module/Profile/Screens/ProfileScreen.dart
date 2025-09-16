import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Logout/Controller/LogoutController.dart';
import '../EditProfileScreen/EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> menuItems = [
    // {"title": "Edit Profile", "icon": Icons.person},
    {"title": "Settings", "icon": Icons.settings},
    {"title": "Log Out", "icon": Icons.logout},
  ];

  final LogoutController controller = Get.put(
    LogoutController(logoutRepo: Get.find()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Icon(menuItems[index]["icon"]),
                title: Text(menuItems[index]["title"]),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle item tap
                  // print("Tapped on ${menuItems[index]["title"]}");
                  // if (menuItems[index]["title"] == "Edit Profile") {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const EditProfileScreen(),
                  //     ),
                  //   );
                  // }
                  if (menuItems[index]["title"] == "Log Out") {
                    // Example logout action
                    // controller.logout();
                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must choose
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text(
                            "Confirm Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Are you sure you want to log out?",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // close dialog
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // close dialog

                                // Show loading buffer effect
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                // Add a small delay to simulate buffer/loading
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );

                                // Call logout controller
                                await controller.logout();

                                // Close loading dialog
                                Navigator.pop(context);

                                // Show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Logged out successfully"),
                                  ),
                                );
                              },
                              child: const Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    print("Tapped on ${menuItems[index]["title"]}");
                  }
                },
              ),
              if (index < menuItems.length) Divider(),
            ],
          );
        },
      ),
    );
  }
}
