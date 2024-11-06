import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/services/helpers/auth_helper.dart';
import 'package:jobility/views/screens/auth/login.dart';

class SignUpNotifier extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool _loader = false;

  bool get loader => _loader;

  set loader(bool newState) {
    _loader = newState;
    notifyListeners();
  }

  final signupFormKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = signupFormKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  signUp(String model) {
    AuthHelper.signup(model).then((response) {
<<<<<<< HEAD
      if (response == true) {
        loader = false;
        Get.offAll(() => const LoginPage());
=======
      loader = false;
      if (response == true) {

        Get.snackbar(
          "Sign Up Successful",
          "Welcome! You can now log in.",
          colorText: Color(kDark.value),
          backgroundColor: Color(kGreen.value),
          icon: const Icon(Icons.check_circle),
        );

        // Navigate to LoginPage after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const LoginPage());
        });
>>>>>>> 80bcbd8 (hehe)
      } else {
        loader = false;
        Get.snackbar("Failed to Sign up", "Please check your credentials",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.add_alert));
      }
    });
  }
}
