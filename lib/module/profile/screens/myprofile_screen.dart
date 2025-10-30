import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erp_admin/module/profile/controller/profile_controller.dart';
import 'package:erp_admin/utils/Constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile();
      controller.fetchBranch(); // ✅ Fetch branch list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text("Could not load profile data."));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, profile),
              const SizedBox(height: 10),
              _buildUserInfo(profile),

              /// Account Info
              _buildInfoCard(
                title: "Account Information",
                children: [
                  _buildInfoTile(Icons.shield_outlined, "Role", profile.type),
                  _buildInfoTile(
                    Icons.toggle_on_outlined,
                    "Status",
                    profile.isActive == 1 ? "Active" : "Inactive",
                  ),
                  Obx(
                    () => _buildInfoTile(
                      Icons.person_add_alt_1_outlined,
                      "Created By",
                      controller.createdByName.value.isNotEmpty
                          ? controller.createdByName.value
                          : "-",
                    ),
                  ),
                ],
              ),

              _branchCard(),

              /// Preferences
              _buildInfoCard(
                title: "Preferences",
                children: [
                  _buildInfoTile(
                    Icons.display_settings_outlined,
                    "Mode",
                    profile.mode,
                  ),
                  _buildInfoTile(
                    Icons.dark_mode_outlined,
                    "Dark Mode",
                    profile.darkMode == true ? "Enabled" : "Disabled",
                  ),
                  _buildInfoTile(
                    Icons.color_lens_outlined,
                    "Messenger Color",
                    profile.messengerColor,
                  ),
                ],
              ),

              /// ✅ Branch Card (Now handles 1 vs. 1+ branches)
              const SizedBox(height: 20),
              // _buildLogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  /// Header Avatar UI
  Widget _buildHeader(BuildContext context, profile) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        Positioned(
          top: 55,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(
                "${Constants.BASEURL}/${profile.avatar ?? ''}",
              ),
              onBackgroundImageError: (_, __) {},
              child: profile.avatar == null
                  ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  /// User Info Section
  Widget _buildUserInfo(profile) {
    return Container(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Text(
            profile.name ?? "No Name",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email ?? "No Email",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Reusable Info Card
  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    EdgeInsetsGeometry? margin,
    Widget? trailing,
    // VoidCallback? onTap,
  }) {
    return Container(
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 12,
                  bottom: 8,
                  right: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailing != null) trailing,
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable tile row (Handles overflow)
  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.5), // Max 50%
        child: Text(
          value ?? "-",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  // --- MODIFICATION: New Helper Widget ---
  /// Reusable helper to build the content of a branch card.
  List<Widget> _buildBranchCardContent(dynamic branch) {
    return [
      ListTile(
        leading: Icon(Icons.location_on_outlined, color: Colors.grey.shade600),
        title: Text(
          branch.branchAddress ?? "No address",
          style: const TextStyle(fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        dense: true,
      ),
      ListTile(
        leading: Icon(Icons.phone_outlined, color: Colors.grey.shade600),
        title: Text(
          branch.contactNumber ?? "No contact",
          style: const TextStyle(fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        dense: true,
      ),
      const SizedBox(height: 8), // Add padding to the bottom
    ];
  }
  // --- END MODIFICATION ---

  // --- MODIFICATION: Updated _branchCard ---
  /// Branch Card Widget (Handles 0, 1, or 1+ branches)
  Widget _branchCard() {
    return Obx(() {
      if (controller.isBranchLoading.value) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [CircularProgressIndicator(color: Colors.green)],
          ),
        );
      }

      if (controller.branchList.isEmpty) {
        return _buildInfoCard(
          title: "Branch",
          children: const [
            ListTile(
              leading: Icon(
                Icons.store_mall_directory_outlined,
                color: Colors.green,
              ),
              title: Text("No branches assigned"),
            ),
          ],
        );
      }

      // --- This is the new logic block ---
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Section Title
          const Padding(
            padding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
            child: Text(
              "Assigned Branch", // Changed from "Branches"
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // 2. UI for ONE branch (Full-width card)
          if (controller.branchList.length == 1)
            _buildInfoCard(
              title: controller.branchList.first.name,
              // Uses default full-width margin
              // trailing: Icon(
              //   Icons.arrow_forward_ios,
              //   size: 16,
              //   color: Colors.grey.shade400,
              // ),
              // onTap: () {
              //   Get.snackbar(
              //     "Branch Tapped",
              //     "Showing details for ${controller.branchList.first.name}",
              //     snackPosition: SnackPosition.BOTTOM,
              //   );
              // },
              children: _buildBranchCardContent(controller.branchList.first),
            )
          // 3. UI for MORE THAN ONE branch (Horizontal scroller)
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: controller.branchList.map((branch) {
                  return SizedBox(
                    width: 300.0, // Fixed width
                    // Fixed height removed to let content decide, or add back if you prefer
                    // height: 170.0,
                    child: _buildInfoCard(
                      margin: const EdgeInsets.only(
                        right: 12.0,
                        bottom: 10,
                        top: 10,
                      ),
                      title: branch.name,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      // onTap: () {
                      //   Get.snackbar(
                      //     "Branch Tapped",
                      //     "Showing details for ${branch.name}",
                      //     snackPosition: SnackPosition.BOTTOM,
                      //   );
                      // },
                      children: _buildBranchCardContent(branch),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      );
      // --- End new logic block ---
    });
  }
  // --- END MODIFICATION ---

  /// Logout Button
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          Get.snackbar(
            "Log Out",
            "Logout functionality coming soon!",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text("Log Out", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
