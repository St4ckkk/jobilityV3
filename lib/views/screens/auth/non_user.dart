import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/common/styled_container.dart';
import 'package:jobility/views/screens/auth/login.dart';

class NonUser extends StatelessWidget {
  const NonUser({super.key});

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://d326fntlu7tb1e.cloudfront.net/uploads/4c004766-c0ad-42ed-bef1-6a7616b24c11-vinci_11.jpg";
    return buildStyleContainer(
        context,
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(99.w)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: 70.w,
                height: 70.w,
              ),
            ),
            const HeightSpacer(size: 20),
            ReusableText(
                text: "To access content please login",
                style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                child: CustomOutlineBtn(
                    width: width,
                    hieght: 40.h,
                    onTap: () {
                      Get.to(() => const LoginPage());
                    },
                    text: "Proceed to Login",
                    color: Color(kOrange.value)))
          ],
        ));
  }
}
