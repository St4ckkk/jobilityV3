import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/screens/jobs/job_details_page.dart';

class UploadedTile extends StatelessWidget {
  const UploadedTile({super.key, required this.job, required this.text});

  final JobsResponse job;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () {
          Get.to(() => JobDetails(
              title: job.title, id: job.id, company: job.company));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
            height: 85,
            width: width,
            decoration: BoxDecoration(
                color: const Color(0x09000000),
                borderRadius: BorderRadius.all(Radius.circular(9.w))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(job.imageUrl),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                                text: job.company,
                                style: appStyle(
                                    12, Color(kDark.value), FontWeight.w500)),
                            SizedBox(
                              width: width * 0.5,
                              child: ReusableText(
                                  text: job.title,
                                  style: appStyle(12, Color(kDarkGrey.value),
                                      FontWeight.w500)),
                            ),
                            ReusableText(
                                text: "${job.salary} per ${job.period}",
                                style: appStyle(12, Color(kDarkGrey.value),
                                    FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                    CustomOutlineBtn(
                      width: 90.w,
                      hieght: 36.h,
                      text: text == 'popular' ? "View" : "Apply",
                      color: Color(kLightBlue.value),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}