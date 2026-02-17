import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../utils/utils.dart';
import '../services/api_service.dart';
import '../services/pref_service.dart';
import '../screens/home_screen.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isSignupLoading = false.obs;
  var isGoogleLoading = false.obs;

  PhoneNumber? phoneNumber;
  var dialCode = '+1'.obs;
  var completePhoneNumber = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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

  void validateAndRegister() {
    final name = fullNameController.text.trim();
    if (name.isEmpty) {
      Utils.showToast("Please enter your full name");
      return;
    }
    if (name.length < 2) {
      Utils.showToast("Full name must be at least 2 characters");
      return;
    }
    if (completePhoneNumber.value.trim().isEmpty) {
      Utils.showToast("Please enter your mobile number");
      return;
    }
    if (completePhoneNumber.value.trim().length < 10) {
      Utils.showToast("Please enter a valid 10-digit mobile number");
      return;
    }
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
    final confirmPassword = confirmPasswordController.text.trim();
    if (confirmPassword.isEmpty) {
      Utils.showToast("Please confirm your password");
      return;
    }
    if (password != confirmPassword) {
      Utils.showToast("Password and confirm password do not match");
      return;
    }
    register();
  }

  Future<void> register() async {
    try {
      isSignupLoading.value = true;

      final res = await ApiService.register({
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "mobile_no": completePhoneNumber.value.trim(),
        "dial_code": dialCode.value,
        "password": passwordController.text.trim(),
      });
      debugPrint('-------register-----res----------$res');

      if (res.success == true) {
        Utils.showToast(res.message ?? "Registration successful");
        Get.back();
      } else {
        Utils.showToast(res.message ?? "Registration failed");
      }
    } catch (e) {
      debugPrint('-------register-----e----------$e');

      Utils.showToast(e.toString());
    } finally {
      isSignupLoading.value = false;
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> registerWithGoogle() async {
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
        Utils.showToast(res.message ?? "Sign up successful");
        Get.offAll(() => const HomeScreen());
      } else {
        Utils.showToast(res.message ?? "Sign up failed");
      }
    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.clear();
    mobileNumberController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    super.onClose();
  }
}
