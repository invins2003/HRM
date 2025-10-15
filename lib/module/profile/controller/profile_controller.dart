import 'package:erp_admin/module/profile/model/profile_model.dart';
import 'package:erp_admin/module/profile/repo/profile_repo.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileController extends GetxController {
  final ProfileRepo profileRepo = ProfileRepo();

  RxBool isLoading = false.obs;
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  RxString createdByName = "".obs; // <-- store the creator's name

  /// Fetch profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await profileRepo.getProfile();
      profile.value = data;

      // Fetch creator's name if createdBy exists
      if (data.createdBy != null) {
        createdByName.value =
            await profileRepo.getUserNameById(data.createdBy!);
      } else {
        createdByName.value = "-";
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
