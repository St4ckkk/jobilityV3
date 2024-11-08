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

  String _userUid = '';

  String get userUid => _userUid;

  set userUid(String uid) {
    _userUid = uid;
    notifyListeners();
  }

  String username = '';
  String name = '';
  String profile = '';

  login(String model, ZoomNotifier zoomNotifier) {
    loader = true;
    AuthHelper.login(model).then((response) async {
      loader = false;
      if (response == true) {
        // Retrieve user UID from SharedPreferences
        userUid = await AuthHelper.getUserUid() ?? '';

        // Debugging statement
        debugPrint('LoginNotifier: Retrieved userUid after login: $userUid');

        if (userUid.isEmpty) {
          debugPrint('Error: userUid is empty or null');
        }

        Get.snackbar(
          "Login Successful",
          "Welcome back! You are now logged in.",
          colorText: Color(kDark.value),
          backgroundColor: Color(kGreen.value),
          icon: const Icon(Icons.check_circle),
        );
        zoomNotifier.currentIndex = 0;
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
      }
    });
  }

  getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    entrypoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
    username = prefs.getString('username') ?? '';
    name = prefs.getString('name') ?? '';
    userUid = prefs.getString('uid') ?? ''; // Ensure this is the correct key

    // Debugging statement
    debugPrint('LoginNotifier: Retrieved userUid from getPref: $userUid');

    if (userUid.isEmpty) {
      debugPrint('Error: userUid is empty or null');
    }

    profile = prefs.getString('profile') ?? '';
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
    await prefs.remove('uid');
  }
}