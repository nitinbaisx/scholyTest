
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class RPhoneField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(PhoneNumber)? onChanged;
  final String initialCountryCode;

  const RPhoneField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.initialCountryCode = 'US',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        IntlPhoneField(
          controller: controller,
          initialCountryCode: initialCountryCode,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "344-344-987",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),
          ),
          flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 12),
          dropdownIconPosition: IconPosition.trailing,
          dropdownTextStyle: const TextStyle(fontSize: 16),
          showCountryFlag: true,
          invalidNumberMessage: 'Invalid phone number',
        ),
      ],
    );
  }
}
