import 'package:schooly/constant/export_utils.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Label(
                  text: 'Logoipsum',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Label(
                          text: 'Login',
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Label(
                            text: "Don't have an account? ",
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(SignupScreen());
                            },
                            child: Label(
                              text: "Sign Up",
                              color: AppColors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Obx(() => Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: controller.selectMobile,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: controller.isMobileSelected.value
                                            ? AppColors.green
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Label(
                                          text: "Mobile",
                                          color:
                                              controller.isMobileSelected.value
                                                  ? AppColors.white
                                                  : AppColors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: controller.selectEmail,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            !controller.isMobileSelected.value
                                                ? AppColors.green
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Label(
                                          text: "Email",
                                          color:
                                              !controller.isMobileSelected.value
                                                  ? Colors.white
                                                  : AppColors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 25),
                      fields(),
                      const SizedBox(height: 25),
                      Obx(() => SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: controller.onContinue,
                              child: controller.isLoginLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Label(
                                      text: "Continue",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                            ),
                          )),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Label(
                              text: "Or",
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Obx(() => SocialButton(
                                text: "Continue with Google",
                                icon: Image.asset(
                                  ImagePath.google,
                                  height: 24,
                                  width: 24,
                                ),
                                isLoading: controller.isGoogleLoading.value,
                                onPressed: controller.loginWithGoogle,
                              )),
                          const SizedBox(height: 10),
                          SocialButton(
                            text: "Continue with Apple",
                            icon: Image.asset(
                              ImagePath.apple,
                              height: 24,
                              width: 24,
                            ),
                            isLoading: false,
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fields() {
    return Obx(() {
      if (controller.isMobileSelected.value) {
        return RPhoneField(
          label: "Mobile Number",
          controller: controller.mobileNumberController,
          initialCountryCode: 'US',
          onChanged: controller.onPhoneNumberChanged,
        );
      } else {
        return Column(
          children: [
            RTextField(
                label: "Email",
                hintText: "dummyEmail@gmail.com",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 8),
            RTextField(
                label: "Password",
                hintText: "********",
                controller: controller.passwordController),
          ],
        );
      }
    });
  }
}
