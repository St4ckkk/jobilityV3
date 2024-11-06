import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/screens/jobs/job_details_page.dart';

class BookMarkTile extends StatelessWidget {
  const BookMarkTile({super.key, required this.bookmark});

  final AllBookMarks bookmark;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () {
          Get.to(() => JobDetails(
              title: bookmark.job.title, id: bookmark.job.id, agentName: bookmark.job.agentName));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
            height: hieght * 0.1,
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
                          backgroundImage: NetworkImage(bookmark.job.imageUrl),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                                text: bookmark.job.company,
                                style: appStyle(
                                    12, Color(kDark.value), FontWeight.w500)),
                            SizedBox(
                              width: width * 0.5,
                              child: ReusableText(
                                  text: bookmark.job.title,
                                  style: appStyle(12, Color(kDarkGrey.value),
                                      FontWeight.w500)),
                            ),
                            ReusableText(
                                text: "${bookmark.job.salary} per ${bookmark.job.period}",
                                style: appStyle(12, Color(kDarkGrey.value),
                                    FontWeight.w500)),
                          ],
                        ),

                        CustomOutlineBtn(
                          width: 90.w,
                          hieght: 36.h,
                          text: "View",
                          color: Color(kLightBlue.value))
                      ],
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
