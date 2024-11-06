import 'package:flutter/material.dart';
import 'package:jobility/views/common/exports.dart';

import '../../../common/height_spacer.dart';


class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/registration-cover.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(kLight.value).withOpacity(0.10),
            child: Column(
              children: [
                const HeightSpacer(size: 150),
                Image.asset('assets/images/header.png',
                  width: 350,
                ),
                const HeightSpacer(size: 100),
                Column(
                  children: [
                    ReusableText(
                      text: "Find Your Dream Job",
                      style: appStyle(
                        30,
                        Color(kDarkBlue.value),
                        FontWeight.w500,
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "Empowering Persons with Disabilities to find meaningful job opportunities that match your unique skills, location, and career goals.",
                        textAlign: TextAlign.center,
                        style: appStyle(14, Color(kDarkBlue.value), FontWeight.normal),
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
