import 'package:schooly/constant/export_utils.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final pinController = TextEditingController();
  var phoneNumber = ''.obs;
  var mobileNo = ''.obs;
  var dialCode = '+91'.obs;
  var isVerifyLoading = false.obs;
  var isResendLoading = false.obs;
  var resendTimer = 60.obs;
  var canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      mobileNo.value = args["mobile_no"] ?? '';
      dialCode.value = args["dial_code"] ?? '+91';
      phoneNumber.value = '${dialCode.value} $mobileNo';
    }
    startResendTimer();
  }

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void validateAndVerifyOtp() {
    final otp = pinController.text.trim();
    if (otp.isEmpty) {
      Utils.showToast("Please enter the OTP");
      return;
    }
    if (otp.length != 4) {
      Utils.showToast("OTP must be 4 digits");
      return;
    }
    if (!RegExp(r'^\d{4}$').hasMatch(otp)) {
      Utils.showToast("OTP must contain only numbers");
      return;
    }
    verifyOtp();
  }

  Future<void> verifyOtp() async {
    try {
      isVerifyLoading.value = true;
      final res = await ApiService.verifyOtp({
        "mobile_no": mobileNo.value,
        "dial_code": dialCode.value,
        "otp": pinController.text.trim(),
      });

      if (res.success == true && res.data != null) {
        final data = res.data!;
        await PrefService.saveUserLogin(
          id: data.toString(),
          token: data.token ?? '',
          name: data.name,
          email: data.email ?? '',
        );
        Utils.showToast(res.message ?? "Verification successful");
        Get.offAll(() => const HomeScreen());
      } else {
        Utils.showToast(res.message ?? "Verification failed");
      }
    } catch (e) {
      debugPrint('-------verifyOtp-e-----$e');
      Utils.showToast(e.toString());
    } finally {
      isVerifyLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value || isResendLoading.value) return;
    try {
      isResendLoading.value = true;
      final res = await ApiService.sendOtp({
        "mobile_no": mobileNo.value,
        "dial_code": dialCode.value,
      });
      if (res.success == true) {
        Utils.showToast(res.message ?? "OTP resent");
        startResendTimer();
      } else {
        Utils.showToast(res.message ?? "Failed to resend OTP");
      }
    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      isResendLoading.value = false;
    }
  }

  String formatPhoneNumber() {
    return '${dialCode.value} ${mobileNo.value}';
  }

  @override
  void onClose() {
    pinController.clear();
    _timer?.cancel();
    super.onClose();
  }
}
