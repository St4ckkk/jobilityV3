import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/services/helpers/auth_helper.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool? _entrypoint;

  bool get entrypoint => _entrypoint ?? false;

  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool? _loggedIn;

  bool get loggedIn => _loggedIn ?? false;

  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  bool _loader = false;

  bool get loader => _loader;

  set loader(bool newState) {
    _loader = newState;
    notifyListeners();
  }

  login(String model, ZoomNotifier zoomNotifier) {
    AuthHelper.login(model).then((response) {
<<<<<<< HEAD
      if (response == true) {
        loader = false;
        zoomNotifier.currentIndex = 0;
        Get.offAll(() => const Mainscreen());
      } else {
        loader = false;
        Get.snackbar("Failed to Sign in", "Please check your credentials",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.add_alert));
=======
      loader = false; // Assuming 'loader' is used to show a loading indicator
      if (response == true) {
        // Show confirmation snackbar
        Get.snackbar(
          "Login Successful",
          "Welcome back! You are now logged in.",
          colorText: Color(kDark.value),
          backgroundColor: Color(kGreen.value), // Use a different color for success
          icon: const Icon(Icons.check_circle),
        );

        zoomNotifier.currentIndex = 0; // Set the current index for the ZoomNotifier
        // Navigate to Mainscreen after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const Mainscreen());
        });
      } else {
        Get.snackbar(
          "Failed to Sign in",
          "Please check your credentials",
          colorText: Color(kLight.value),
          backgroundColor: Color(kOrange.value),
          icon: const Icon(Icons.add_alert),
        );
>>>>>>> 80bcbd8 (hehe)
      }
    });
  }

<<<<<<< HEAD
=======

>>>>>>> 80bcbd8 (hehe)
  getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    entrypoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
    username = prefs.getString('username') ?? '';
    name = prefs.getString('name') ?? '';
    userUid = prefs.getString('uid') ?? '';
    profile = prefs.getString('profile') ?? '';
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
  }
}
