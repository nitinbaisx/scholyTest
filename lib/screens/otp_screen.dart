import 'package:schooly/constant/export_utils.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white)),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Logo
                  const Expanded(
                    child: Center(
                      child: Label(
                        text: 'Logoipsum',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        const Label(
                          text: 'Verify OTP',
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'We sent the verification code to your',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'registered mobile number',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        Obx(() => Text(
                              controller.formatPhoneNumber(),
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(height: 32),

                        OtpInputWidget(
                          length: 4,
                          controller: controller.pinController,
                          showCursor: true,
                          borderColor: Colors.grey.shade300,
                          focusedBorderColor: AppColors.green,
                          fieldSize: 60,
                          onCompleted: (pin) {},
                        ),
                        const SizedBox(height: 32),

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
                                onPressed: controller.isVerifyLoading.value
                                    ? null
                                    : controller.validateAndVerifyOtp,
                                child: controller.isVerifyLoading.value
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

                        Obx(() => GestureDetector(
                              onTap: (controller.canResend.value &&
                                      !controller.isResendLoading.value)
                                  ? controller.resendOtp
                                  : null,
                              child: controller.isResendLoading.value
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppColors.green,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      controller.canResend.value
                                          ? 'Resend Verification'
                                          : 'Resend Verification (${controller.resendTimer.value}s)',
                                      style: TextStyle(
                                        color: controller.canResend.value
                                            ? Colors.black
                                            : Colors.grey.shade400,
                                        fontSize: 14,
                                        decoration: controller.canResend.value
                                            ? TextDecoration.underline
                                            : null,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
