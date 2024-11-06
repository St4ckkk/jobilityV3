import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/height_spacer.dart';
import '../../auth/login.dart';
import '../../auth/registration.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            width: width,
            height: height,
            child: Image.asset(
              'assets/images/cover.jpg', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Main content with semi-transparent overlay
          Container(
            width: width,
            height: height,

            child: Column(
              children: [
                const SizedBox(height: 200),
                Image.asset("assets/images/page-3.png",
                  width: 350,
                ),
                const HeightSpacer(size: 20),
                ReusableText(
                  text: "Welcome To Jobility",
                  style: appStyle(30, kLight, FontWeight.w600),
                ),
                const HeightSpacer(size: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    "We specialize in helping individuals with disabilities find meaningful job opportunities that match their skills, preferences, and location, enabling you to build a rewarding career.",
                    textAlign: TextAlign.center,
                    style: appStyle(14, kLight, FontWeight.normal),
                  ),
                ),
                const HeightSpacer(size: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomOutlineBtn(
                      onTap: () async {
                        final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setBool('entrypoint', true);
                        Get.to(() => const LoginPage());
                      },
                      text: 'Login',
                      width: width * .4,
                      hieght: height * 0.06,
                      color: Color(kLight.value),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const RegistrationPage());
                      },
                      child: Container(
                        width: width * .4,
                        height: height * 0.06,
                        color: Color(kLight.value),
                        child: Center(
                          child: ReusableText(
                            text: "Sign Up",
                            style: appStyle(
                              16,
                              kLightBlue,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const HeightSpacer(size: 25),
                GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();

                    prefs.setBool('entrypoint', true);
                    Get.to(() => const Mainscreen());
                  },
                  child: ReusableText(
                    text: "Continue as guest",
                    style: appStyle(
                      16,
                      Color(kLight.value),
                      FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
