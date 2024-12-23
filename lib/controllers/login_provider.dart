import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/services/helpers/auth_helper.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  bool _obscureText = true;
  bool? _entrypoint;
  bool? _loggedIn;
  bool _loader = false;

  String username = '';
  String name = '';
  String userUid = '';
  String profile = '';

  bool get obscureText => _obscureText;
  bool get entrypoint => _entrypoint ?? false;
  bool get loggedIn => _loggedIn ?? false;
  bool get loader => _loader;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  set loader(bool newState) {
    _loader = newState;
    notifyListeners();
  }

  Future<void> login(String model, ZoomNotifier zoomNotifier) async {
    loader = true;
    bool response = await AuthHelper.login(model);
    loader = false;

    if (response) {
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
  }

  Future<void> getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    entrypoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
    username = prefs.getString('username') ?? '';
    name = prefs.getString('name') ?? '';
    userUid = prefs.getString('uid') ?? '';
    profile = prefs.getString('profile') ?? '';
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
    await prefs.remove('uid');
    await prefs.remove('profile');
    await prefs.remove('username');
    await prefs.remove('name');
  }
}