import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:schooly/utils/utils.dart';
import 'package:schooly/services/api_service.dart';
import 'package:schooly/services/pref_service.dart';
import 'package:schooly/screens/otp_screen.dart';
import 'package:schooly/screens/home_screen.dart';

class LoginController extends GetxController {
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isMobileSelected = true.obs;
  var rememberMe = false.obs;
  var isLoginLoading = false.obs;
  var isGoogleLoading = false.obs;
  PhoneNumber? phoneNumber;
  var dialCode = '+1'.obs;
  var completePhoneNumber = ''.obs;

  void selectMobile() {
    if (isClosed) return;
    isMobileSelected.value = true;
    emailController.clear();
    passwordController.clear();
  }

  void selectEmail() {
    if (isClosed) return;
    isMobileSelected.value = false;
    mobileNumberController.clear();
    completePhoneNumber.value = '';
  }

  void onPhoneNumberChanged(PhoneNumber? number) {
    phoneNumber = number;

    if (number != null) {
      String code = number.countryCode;
      code = code.replaceAll('+', '');
      dialCode.value = '+$code';

      completePhoneNumber.value = number.number;
    } else {
      completePhoneNumber.value = '';
    }
  }

  void validateEmailLogin() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Utils.showToast("Please enter your email address");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Utils.showToast("Please enter a valid email address");
      return;
    }
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      Utils.showToast("Please enter your password");
      return;
    }
    if (password.length < 6) {
      Utils.showToast("Password must be at least 6 characters");
      return;
    }
    loginWithEmail();
  }

  Future<void> loginWithEmail() async {
    try {
      isLoginLoading.value = true;
      final res = await ApiService.login({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });

      if (res.success == true && res.data != null) {
        final data = res.data!;
        await PrefService.saveUserLogin(
          id: (data.id ?? 0).toString(),
          token: data.token ?? '',
          name: data.name,
          email: data.email ?? '',
        );
        Utils.showToast(res.message ?? "Login successful");
        Get.offAll(() => const HomeScreen());
      } else {
        Utils.showToast(res.message ?? "Login failed");
      }
    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      isLoginLoading.value = false;
    }
  }

  void validateMobileLogin() {
    if (completePhoneNumber.value.isEmpty) {
      Utils.showToast("Please enter your mobile number");
      return;
    }
    if (completePhoneNumber.value.length < 10) {
      Utils.showToast("Please enter a valid 10-digit mobile number");
      return;
    }
    sendOtp();
  }

  Future<void> sendOtp() async {
    try {
      isLoginLoading.value = true;
      final res = await ApiService.sendOtp({
        "mobile_no": completePhoneNumber.value,
        "dial_code": dialCode.value,
      });

      if (res.success == true) {
        Utils.showToast(res.message ?? "OTP sent");
        Get.to(() => const OtpScreen(), arguments: {
          "mobile_no": completePhoneNumber.value,
          "dial_code": dialCode.value,
        });
      } else {
        Utils.showToast(res.message ?? "Failed to send OTP");
      }
    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      isLoginLoading.value = false;
    }
  }

  void onContinue() {
    if (isMobileSelected.value) {
      validateMobileLogin();
    } else {
      validateEmailLogin();
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user == null) {
        Utils.showToast("Google sign in cancelled");
        return;
      }
      final res = await ApiService.socialLogin({
        "name": user.displayName ?? '',
        "email": user.email,
        "social_id": user.id,
        "login_type": "google",
      });
      if (res.success == true && res.data != null) {
        final data = res.data!;
        await PrefService.saveUserLogin(
          id: (data.id ?? 0).toString(),
          token: data.token ?? '',
          name: data.name,
          email: data.email ?? '',
        );
        Utils.showToast(res.message ?? "Login successful");
        Get.offAll(() => const HomeScreen());
      } else {
        Utils.showToast(res.message ?? "Login failed");
      }
    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    mobileNumberController.clear();
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
