import 'dart:developer';

import 'package:erp_admin/module/EmployeeList&Profile/Model/EmployeeProfileModel/EmployeeProfileModel.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Repo/ProfileRepo/EmployeeProfileRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeProfileController extends GetxController {
  EmployeeProfileRepo employeeProfileRepo;
  EmployeeProfileController({required this.employeeProfileRepo});
  RxBool isloading = false.obs;

  // var Profiledata = <EmployeeProfileModel>[].obs;
  var Profiledata = EmployeeProfileModel().obs;

  Future<void> profileController(int id) async {
    try {
      isloading.value = true;
      Response response = await employeeProfileRepo.profileRepo(id);
      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        final profileModel = EmployeeProfileModel.fromJson(response.body);
        // Fluttertoast.showToast(
        //   msg: "Response StatusCode : ${response.statusCode}",
        // );
        // List<dynamic> data = response.body;
        // Profiledata.value = data
        //     .map((e) => EmployeeProfileModel.fromJson(e))
        //     .toList();
        Profiledata.value = profileModel;
        if (profileModel.success == true && profileModel.data != null) {
          // Profiledata.assignAll([profileModel.data!]);
          Get.snackbar(
            "Profile",
            "Fetch Profile Successully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          // Fluttertoast.showToast(msg: "Status UnSucces");
          Get.snackbar(
            "Status",
            "Status UnSucces",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to load profile",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Fluttertoast.showToast(
        //   msg: "Error StatusCode = ${response.statusCode}",
        // );
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "ERROR --- ${e}");
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      log("ERROR -->.. > ${e}");
    } finally {
      isloading.value = false;
    }
  }
}
