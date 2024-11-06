import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/views/common/app_style.dart';

import '../../../common/height_spacer.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

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
              'assets/images/cover.jpg', // Update with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay content
          Container(
            width: width,
            height: height,
            child: Column(
              children: [
                const HeightSpacer(size: 150),
                Padding(
                  padding: EdgeInsets.all(8.0.h),
                  child: Image.asset(
                    "assets/icons/app_logo.png",
                    width: 400,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                const HeightSpacer(size: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Stable yourself \n with your ability",
                      textAlign: TextAlign.center,
                      style: appStyle(30, Color(kLight.value), FontWeight.w500),
                    ),
                    const HeightSpacer(size: 10),
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Text(
                        "We help you find job opportunities that match your skills, location, and goals to advance your career.",
                        textAlign: TextAlign.center,
                        style: appStyle(
                          14,
                          Color(kLight.value),
                          FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}