import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/models/response/jobs/get_jobAlerts.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/screens/jobs/job_details_page.dart';

import '../../../common/BackBtn.dart';
import '../../../common/app_bar.dart';

class ViewAllJobAlerts extends StatelessWidget {
  final List<JobAlert> jobAlerts;

  const ViewAllJobAlerts({super.key, required this.jobAlerts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.w),
        child: const CustomAppBar(
          text: "Job Alerts",
          child: BackBtn(),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.w),
        itemCount: jobAlerts.length,
        itemBuilder: (context, index) {
          var alert = jobAlerts[index];
          return FittedBox(
            child: GestureDetector(
              onTap: () {
                Get.to(() => JobDetails(
                  title: alert.jobId.title,
                  id: alert.jobId.id,
                  agentName: alert.jobId.agentName,
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0x09000000),
                    borderRadius: BorderRadius.all(Radius.circular(9.w)),
                  ),
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
                                backgroundImage: NetworkImage(alert.jobId.imageUrl),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text: alert.jobId.company,
                                    style: appStyle(12, Color(kDark.value), FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: ReusableText(
                                      text: alert.jobId.title,
                                      style: appStyle(12, Color(kDarkGrey.value), FontWeight.w500),
                                    ),
                                  ),
                                  ReusableText(
                                    text: "${alert.jobId.salary} per ${alert.jobId.period}",
                                    style: appStyle(12, Color(kDarkGrey.value), FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CustomOutlineBtn(
                            width: 90.w,
                            hieght: 36.h,
                            text: "View",
                            color: Color(kLightBlue.value),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}