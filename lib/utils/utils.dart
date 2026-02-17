import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static void showToast(String message) {
    final context = Get.context;

    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
