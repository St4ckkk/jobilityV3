import 'dart:ui';
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
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/response/jobs/accepted_disability.dart';
import '../auth/profile_page.dart';

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
  TextEditingController imageController = TextEditingController(
      text:
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg");
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

  List<TextEditingController> requirementControllers = [];
  List<AcceptedDisability> acceptedDisabilities = [];
  List<String> disabilityTypes = [
    "Visual",
    "Hearing",
    "Mobility",
    "Cognitive",
    "Speech",
    "Mental Health",
    "Learning",
    "Chronic Illness",
    "Other"
  ];
  String selectedDisabilityType = "Visual";

  @override
  void initState() {
    super.initState();
    requirementControllers.add(TextEditingController());
  }

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
                      padding: const EdgeInsets.all(12.0),
                      child: CircularAvata(
                          image: skillsNotifier.logoUrl, w: 30, h: 40),
                    )
                        : const SizedBox.shrink();
                  },
                )
              ],
              color: Color(kNewBlue.value),
              text: "Upload Jobs",
              child: const BackBtn())),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/registration-cover.jpg',
              fit: BoxFit.cover,
            ),
          ),
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
                    color: Colors.transparent),
                child: buildStyleContainer(
                    context,
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const HeightSpacer(size: 10),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ReusableText(
                                              text: "Job Details",
                                              style: appStyle(18, Colors.black, FontWeight.bold)),
                                          const HeightSpacer(size: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
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
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
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
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
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
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
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
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
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
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
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
                                              ),
                                            ],
                                          ),
                                          Consumer<SkillsNotifier>(
                                            builder: (context, skillsNotifier, child) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 4.0),
                                                      child: buildtextfield(
                                                          onChanged: (value) {
                                                            skillsNotifier.setLogoUrl(
                                                                imageController.text);
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
                                                          controller: imageController),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      skillsNotifier
                                                          .setLogoUrl(imageController.text);
                                                    },
                                                    child: Icon(Entypo.upload_to_cloud,
                                                        size: 35,
                                                        color: Color(kNewBlue.value)),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ReusableText(
                                              text: "Requirements",
                                              style: appStyle(18, Colors.black, FontWeight.bold)),
                                          const HeightSpacer(size: 10),
                                          ...requirementControllers.map((controller) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 4.0),
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
                                                  label: const Text("Requirement"),
                                                  hintText: "Requirement",
                                                  controller: controller),
                                            );
                                          }).toList(),
                                          CustomOutlineBtn(
                                              width: width,
                                              onTap: () {
                                                setState(() {
                                                  requirementControllers.add(TextEditingController());
                                                });
                                              },
                                              hieght: 40.h,
                                              text: "Add Requirement",
                                              color: Color(kNewBlue.value)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ReusableText(
                                              text: "Accepted Disabilities",
                                              style: appStyle(18, Colors.black, FontWeight.bold)),
                                          const HeightSpacer(size: 10),
                                          ...acceptedDisabilities.map((disability) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 4.0),
                                              child: Column(
                                                children: [
                                                  DropdownButtonFormField<String>(
                                                    value: disability.type.isNotEmpty ? disability.type : selectedDisabilityType,
                                                    items: disabilityTypes.map((String type) {
                                                      return DropdownMenuItem<String>(
                                                        value: type,
                                                        child: Text(type),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        disability.type = newValue!;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: "Disability Type",
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  buildtextfield(
                                                      onSubmitted: (value) {
                                                        if (value!.isEmpty) {
                                                          return ("Please fill the field");
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      label: const Text("Specific Names"),
                                                      hintText: "Specific Names",
                                                      controller: TextEditingController(text: disability.specificNames.join(', '))),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          CustomOutlineBtn(
                                              width: width,
                                              onTap: () {
                                                setState(() {
                                                  acceptedDisabilities.add(AcceptedDisability(type: selectedDisabilityType, specificNames: []));
                                                });
                                              },
                                              hieght: 40.h,
                                              text: "Add Disability",
                                              color: Color(kNewBlue.value)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomOutlineBtn(
                                width: width,
                                onTap: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  String agentId = prefs.getString("agentId") ?? "";
                                  String agentName = prefs.getString("username") ?? "";

                                  if (agentId.isEmpty) {
                                    print('Agent ID is missing');
                                    return;
                                  }

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
                                      agentId: agentId,
                                      requirements: requirementControllers.map((controller) => controller.text).toList(),
                                      agentName: agentName,
                                      acceptedDisabilities: acceptedDisabilities);

                                  var model = createJobsRequestToJson(rawModel);

                                  bool success = await JobsHelper.createJob(model);

                                  if (success) {
                                    print('Job created successfully');
                                    zoomNotifier.currentIndex = 0;
                                    Get.to(() => const Mainscreen());
                                  } else {
                                    print('Failed to create job');
                                  }
                                },
                                hieght: 40.h,
                                text: "Submit",
                                color: Color(kNewBlue.value)),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}