import 'package:schooly/constant/export_utils.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupController controller = Get.put(SignupController());

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
                          text: 'Sign up',
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
                            text: "Already have an account? ",
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Label(
                              text: "Login",
                              color: AppColors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      buildFormFields(),
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
                              onPressed: controller.validateAndRegister,
                              child: controller.isSignupLoading.value
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
                                onPressed: controller.registerWithGoogle,
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

  Widget buildFormFields() {
    return Column(
      children: [
        RTextField(
          label: "Full Name",
          hintText: "Lokin Aderson",
          controller: controller.fullNameController,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        RPhoneField(
          label: "Mobile Number",
          controller: controller.mobileNumberController,
          initialCountryCode: 'US',
          onChanged: controller.onPhoneNumberChanged,
        ),
        const SizedBox(height: 16),
        RTextField(
          label: "Email Address",
          hintText: "dummyEmail@gmail.com",
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        Obx(() => RTextField(
              label: "Password",
              hintText: "********",
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            )),
        const SizedBox(height: 16),
        Obx(() => RTextField(
              label: "Confirm Password",
              hintText: "********",
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: controller.toggleConfirmPasswordVisibility,
              ),
            )),
      ],
    );
  }
}
