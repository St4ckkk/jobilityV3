import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/models/response/applied/applied.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/screens/jobs/job_details_page.dart';

class AppliedTile extends StatelessWidget {
  const AppliedTile({super.key, required this.job, required this.status});

  final Job job;
  final String status;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => JobDetails(
            title: job.title, id: job.id, company: job.agentName));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
          decoration: BoxDecoration(
              color: const Color(0x09000000),
              borderRadius: BorderRadius.all(Radius.circular(9.w))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.w,
                backgroundImage: job!.imageUrl.startsWith('http')
                    ? NetworkImage(job.imageUrl)
                    : FileImage(File(job.imageUrl)) as ImageProvider,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: ReusableText(
                        text: status,
                        style: appStyle(12, Colors.white, FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomOutlineBtn(
                width: 90.w,
                hieght: 36.h,
                text: "View",
                color: Color(kLightBlue.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}