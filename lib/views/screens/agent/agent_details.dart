import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/controllers/agents_provider.dart';
import 'package:jobility/models/response/agent/getAgent.dart';
import 'package:jobility/views/common/BackBtn.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:jobility/views/common/styled_container.dart';
import 'package:jobility/views/common/width_spacer.dart';
import 'package:jobility/views/screens/agent/agent_jobs.dart';
import 'package:jobility/views/screens/auth/profile_page.dart';
import 'package:provider/provider.dart';

class AgentDetails extends StatelessWidget {
  const AgentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(12.w),
          child: BackBtn(
            color: Color(kLight.value),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                height: 140.h,
                decoration: BoxDecoration(
                  color: Color(kNewBlue.value),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w),
                  ),
                ),
                child: Column(
                  children: [
                    Consumer<AgentNotifier>(
                      builder: (context, agentNotifier, child) {
                        var agent = agentNotifier.agent;
                        var agentInfo = agentNotifier.getAgentInfo(agent!.uid);
                        return Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReusableText(
                                          text: 'Company',
                                          style: appStyle(
                                              11,
                                              Color(kLight.value),
                                              FontWeight.w500)),
                                      ReusableText(
                                          text: 'Address',
                                          style: appStyle(
                                              11,
                                              Color(kLight.value),
                                              FontWeight.w500)),
                                      ReusableText(
                                          text: 'Working Hours',
                                          style: appStyle(
                                              11,
                                              Color(kLight.value),
                                              FontWeight.w500)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Container(
                                      height: 60.w,
                                      width: 1.w,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                  FutureBuilder<GetAgent>(
                                      future: agentInfo,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox.shrink();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          var data = snapshot.data;
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ReusableText(
                                                  text: data!.company,
                                                  style: appStyle(
                                                      11,
                                                      Color(kLight.value),
                                                      FontWeight.w500)),
                                              ReusableText(
                                                  text: data.hqAddress,
                                                  style: appStyle(
                                                      11,
                                                      Color(kLight.value),
                                                      FontWeight.w500)),
                                              ReusableText(
                                                  text: data.workingHrs,
                                                  style: appStyle(
                                                      11,
                                                      Color(kLight.value),
                                                      FontWeight.w500)),
                                            ],
                                          );
                                        }
                                      })
                                ],
                              ),

                             const  WidthSpacer(width: 20),
                             CircularAvata(image: agent.profile, w: 50, h: 50)
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              )),
          Positioned(
              top: 80.h,
              right: 0,
              left: 0,
              child: Container(
                width: width,
                height: hieght*0.8,
                decoration: BoxDecoration(
                  color:  Color(kGreen.value),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w),
                  ),
                ),
                child: buildStyleContainer(
                  context,
                  const AgentJobs()),
              ))
        ],
      ),
    );
  }
}
