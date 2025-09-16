import 'dart:developer';

import 'package:erp_admin/module/EmployeeList&Profile/Model/EmployeeProfileModel/EmployeeProfileModel.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Repo/ProfileRepo/EmployeeProfileRepo.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        Fluttertoast.showToast(
          msg: "Response StatusCode : ${response.statusCode}",
        );
        // List<dynamic> data = response.body;
        // Profiledata.value = data
        //     .map((e) => EmployeeProfileModel.fromJson(e))
        //     .toList();
        Profiledata.value = profileModel;
        if (profileModel.success == true && profileModel.data != null) {
          // Profiledata.assignAll([profileModel.data!]);
          Get.snackbar("Profile", "Fetch Profile Successully");
        } else {
          Fluttertoast.showToast(msg: "Status UnSucces");
        }
      } else {
        Get.snackbar("Error", "Failed to load profile");
        Fluttertoast.showToast(
          msg: "Error StatusCode = ${response.statusCode}",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "ERROR --- ${e}");

      log("ERROR -->.. > ${e}");
    } finally {
      isloading.value = false;
    }
  }
}
