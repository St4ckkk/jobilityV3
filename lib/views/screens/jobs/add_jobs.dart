import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/skills_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/models/request/jobs/create_job.dart';
import 'package:jobility/services/helpers/jobs_helper.dart';
import 'package:jobility/views/common/BackBtn.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/common/styled_container.dart';
import 'package:jobility/views/common/textfield.dart';
import 'package:jobility/views/screens/auth/profile_page.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobs extends StatefulWidget {
  const AddJobs({super.key});

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  TextEditingController title = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController contract = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController period = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
  TextEditingController rq1 = TextEditingController();
  TextEditingController rq2 = TextEditingController();
  TextEditingController rq3 = TextEditingController();
  TextEditingController rq4 = TextEditingController();
  TextEditingController rq5 = TextEditingController();
<<<<<<< HEAD
  TextEditingController imageController = TextEditingController(
      text:
          "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg");
=======
  TextEditingController acceptedDisabilitiesController = TextEditingController();
>>>>>>> 80bcbd8 (hehe)
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

  @override
  Widget build(BuildContext context) {
    var skillsNotifier = Provider.of<SkillsNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.w),
          child: CustomAppBar(
              actions: [
                Consumer<SkillsNotifier>(
                  builder: (context, skillsNotifier, child) {
                    return skillsNotifier.logoUrl.isNotEmpty
                        ? Padding(
<<<<<<< HEAD
                            padding: const EdgeInsets.all(12.0),
                            child: CircularAvata(
                                image: skillsNotifier.logoUrl, w: 30, h: 40),
                          )
=======
                      padding: const EdgeInsets.all(12.0),
                      child: CircularAvata(
                          image: skillsNotifier.logoUrl, w: 30, h: 40),
                    )
>>>>>>> 80bcbd8 (hehe)
                        : const SizedBox.shrink();
                  },
                )
              ],
              color: Color(kNewBlue.value),
              text: "Upload Jobs",
              child: const BackBtn())),
      body: Stack(
        children: [
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(kLight.value)),
                child: buildStyleContainer(
                    context,
                    Padding(
                      padding:
<<<<<<< HEAD
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
=======
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
>>>>>>> 80bcbd8 (hehe)
                      child: ListView(
                        children: [
                          const HeightSpacer(size: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Job Title"),
                                hintText: "Job Title",
                                controller: title),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Company"),
                                hintText: "Company",
                                controller: company),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Location"),
                                hintText: "Location",
                                controller: location),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Contract"),
                                hintText: "Contract",
                                controller: contract),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Salary"),
                                hintText: "Salary",
                                controller: salary),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Salary period"),
                                hintText: "Monthly | Annual | Weekly",
                                controller: period),
                          ),
                          Consumer<SkillsNotifier>(
                            builder: (context, skillsNotifier, child) {
                              return SizedBox(
                                width: width,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
<<<<<<< HEAD
                                      MainAxisAlignment.spaceBetween,
=======
                                  MainAxisAlignment.spaceBetween,
>>>>>>> 80bcbd8 (hehe)
                                  children: [
                                    SizedBox(
                                      width: width * 0.8,
                                      height: 60,
                                      child: buildtextfield(
                                          onChanged: (value) {
                                            skillsNotifier.setLogoUrl(
<<<<<<< HEAD
                                                imageController.text);
=======
                                                imageUrl.text);
>>>>>>> 80bcbd8 (hehe)
                                          },
                                          onSubmitted: (value) {
                                            if (value!.isEmpty &&
                                                value.contains('https://')) {
                                              return ("Please fill the field");
                                            } else {
                                              return null;
                                            }
                                          },
                                          label: const Text("Image Url"),
                                          hintText: "Image Url",
<<<<<<< HEAD
                                          controller: imageController),
=======
                                          controller: imageUrl),
>>>>>>> 80bcbd8 (hehe)
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        skillsNotifier
<<<<<<< HEAD
                                            .setLogoUrl(imageController.text);
=======
                                            .setLogoUrl(imageUrl.text);
>>>>>>> 80bcbd8 (hehe)
                                      },
                                      child: Icon(Entypo.upload_to_cloud,
                                          size: 35,
                                          color: Color(kNewBlue.value)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                height: 100,
                                maxLines: 3,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Description"),
                                hintText: "Description",
                                controller: description),
                          ),
                          ReusableText(
                              text: "Requirements",
                              style:
<<<<<<< HEAD
                                  appStyle(15, Colors.black, FontWeight.w600)),
=======
                              appStyle(15, Colors.black, FontWeight.w600)),
>>>>>>> 80bcbd8 (hehe)
                          const HeightSpacer(size: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq1),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq2),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq4),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
                                hintText: "Requirements",
                                controller: rq5),
                          ),
<<<<<<< HEAD
                          CustomOutlineBtn(
                              width: width,
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String agentName =
                                    prefs.getString("username") ?? "";
=======
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                              onSubmitted: (value) {
                                if (value!.isEmpty && !value.contains('https://')) {
                                  return ("Please fill the field with a valid URL");
                                } else {
                                  return null;
                                }
                              },
                              label: const Text("Accepted Disabilities"),
                              hintText: "Accepted Disabilities",
                              controller: acceptedDisabilitiesController,
                            ),
                          ),
                          CustomOutlineBtn(
                              width: width,
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String agentName = prefs.getString("username") ?? "";

                                List<AcceptedDisability> acceptedDisabilities = [];
                                if (acceptedDisabilitiesController.text.isNotEmpty) {
                                  List<String> disabilityTypes = acceptedDisabilitiesController.text.split(',');
                                  for (String type in disabilityTypes) {
                                    String? specificNamesString = type.split('|').length > 1 ? type.split('|')[1].trim() : null;
                                    List<String> specificNames = specificNamesString != null
                                        ? specificNamesString.split(',').map((name) => name.trim()).toList()
                                        : [];
                                    acceptedDisabilities.add(
                                      AcceptedDisability(
                                        type: type.split('|')[0].trim(),
                                        specificNames: specificNames,
                                      ),
                                    );
                                  }
                                }
>>>>>>> 80bcbd8 (hehe)

                                CreateJobsRequest rawModel = CreateJobsRequest(
                                    title: title.text,
                                    location: location.text,
                                    company: company.text,
                                    hiring: true,
                                    description: description.text,
                                    salary: salary.text,
                                    period: period.text,
                                    contract: contract.text,
                                    imageUrl: skillsNotifier.logoUrl,
                                    agentId: userUid,
<<<<<<< HEAD
=======
                                    agentName: agentName,
>>>>>>> 80bcbd8 (hehe)
                                    requirements: [
                                      rq1.text,
                                      rq2.text,
                                      rq3.text,
                                      rq4.text,
                                      rq5.text,
                                    ],
<<<<<<< HEAD
                                    agentName: agentName);
=======
                                    acceptedDisabilities: acceptedDisabilities);
>>>>>>> 80bcbd8 (hehe)

                                var model = createJobsRequestToJson(rawModel);

                                JobsHelper.createJob(model);
                                zoomNotifier.currentIndex = 0;
                                Get.to(() => const Mainscreen());
                              },
                              hieght: 40.h,
                              text: "Submit",
                              color: Color(kNewBlue.value))
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 80bcbd8 (hehe)
