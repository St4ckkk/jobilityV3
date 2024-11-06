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

class UpdateJobs extends StatefulWidget {
  const UpdateJobs({super.key});

  @override
  State<UpdateJobs> createState() => _UpdateJobsState();
}

class _UpdateJobsState extends State<UpdateJobs> {
<<<<<<< HEAD
=======
  // Existing job details controllers
>>>>>>> 80bcbd8 (hehe)
  TextEditingController title = TextEditingController(text: jobUpdate!.title);
  TextEditingController company = TextEditingController(text: jobUpdate!.company);
  TextEditingController location = TextEditingController(text: jobUpdate!.location);
  TextEditingController salary = TextEditingController(text: jobUpdate!.salary);
  TextEditingController contract = TextEditingController(text: jobUpdate!.contract);
  TextEditingController description = TextEditingController(text: jobUpdate!.description);
  TextEditingController period = TextEditingController(text: jobUpdate!.period);
<<<<<<< HEAD
  TextEditingController imageUrl = TextEditingController(text: jobUpdate!.title);
  TextEditingController rq1 = TextEditingController(text: jobUpdate!.requirements[0]);
  TextEditingController rq2 = TextEditingController(text: jobUpdate!.requirements[1]);
  TextEditingController rq3 = TextEditingController(text:jobUpdate!.requirements[2]);
  TextEditingController rq4 = TextEditingController(text: jobUpdate!.requirements[3]);
  TextEditingController rq5 = TextEditingController(text: jobUpdate!.requirements[4]
  );
  TextEditingController imageController = TextEditingController(
      text: jobUpdate!.imageUrl);
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";
=======
  TextEditingController imageUrl = TextEditingController(text: jobUpdate!.imageUrl);
  TextEditingController rq1 = TextEditingController(text: jobUpdate!.requirements[0]);
  TextEditingController rq2 = TextEditingController(text: jobUpdate!.requirements[1]);
  TextEditingController rq3 = TextEditingController(text: jobUpdate!.requirements[2]);
  TextEditingController rq4 = TextEditingController(text: jobUpdate!.requirements[3]);
  TextEditingController rq5 = TextEditingController(text: jobUpdate!.requirements[4]);
  TextEditingController imageController = TextEditingController(text: jobUpdate!.imageUrl);

  // Controllers for disabilities
  TextEditingController disabilityType = TextEditingController();
  TextEditingController specificName = TextEditingController();
  List<AcceptedDisability> acceptedDisabilities = []; // Initialize list to hold accepted disabilities

  // Helper function to add disability entry
  void addDisability() {
    if (disabilityType.text.isNotEmpty && specificName.text.isNotEmpty) {
      setState(() {
        acceptedDisabilities.add(AcceptedDisability(
          type: disabilityType.text,
          specificNames: [specificName.text],
        ));
        disabilityType.clear();
        specificName.clear();
      });
    }
  }
>>>>>>> 80bcbd8 (hehe)

  @override
  Widget build(BuildContext context) {
    var skillsNotifier = Provider.of<SkillsNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
<<<<<<< HEAD
=======

>>>>>>> 80bcbd8 (hehe)
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.w),
          child: CustomAppBar(
              actions: [
<<<<<<< HEAD
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
=======
                Consumer<SkillsNotifier>(builder: (context, skillsNotifier, child) {
                  return skillsNotifier.logoUrl.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircularAvata(
                        image: skillsNotifier.logoUrl, w: 30, h: 40),
                  )
                      : const SizedBox.shrink();
                })
              ],
              color: Color(kNewBlue.value),
              text: "Update Jobs",
>>>>>>> 80bcbd8 (hehe)
              child: const BackBtn())),
      body: Stack(
        children: [
          Positioned(
<<<<<<< HEAD
              right: 0,
              left: 0,
              bottom: 0,
              top: 0,
              child: Container(
=======
            right: 0,
            left: 0,
            bottom: 0,
            top: 0,
            child: Container(
>>>>>>> 80bcbd8 (hehe)
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color(kLight.value)),
                child: buildStyleContainer(
                    context,
                    Padding(
<<<<<<< HEAD
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
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
=======
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
                      child: ListView(
                        children: [
                          const HeightSpacer(size: 20),
                          // Job Title
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Job Title"),
                                hintText: "Job Title",
                                controller: title),
                          ),
<<<<<<< HEAD
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
=======
                          // Company
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Company"),
                                hintText: "Company",
                                controller: company),
                          ),
<<<<<<< HEAD
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
=======
                          // Location
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Location"),
                                hintText: "Location",
                                controller: location),
                          ),
<<<<<<< HEAD
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
=======
                          // Contract
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Contract"),
                                hintText: "Contract",
                                controller: contract),
                          ),
<<<<<<< HEAD
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
=======
                          // Salary
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Salary"),
                                hintText: "Salary",
                                controller: salary),
                          ),
<<<<<<< HEAD
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
=======
                          // Salary Period
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Salary period"),
                                hintText: "Monthly | Annual | Weekly",
                                controller: period),
                          ),
<<<<<<< HEAD
=======
                          // Image URL
>>>>>>> 80bcbd8 (hehe)
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
                                                imageController.text);
                                          },
<<<<<<< HEAD
                                          onSubmitted: (value) {
                                            if (value!.isEmpty &&
                                                value.contains('https://')) {
                                              return ("Please fill the field");
                                            } else {
                                              return null;
                                            }
                                          },
=======
>>>>>>> 80bcbd8 (hehe)
                                          label: const Text("Image Url"),
                                          hintText: "Image Url",
                                          controller: imageController),
                                    ),
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
                                ),
                              );
                            },
                          ),
<<<<<<< HEAD
=======
                          // Job Description
>>>>>>> 80bcbd8 (hehe)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                height: 100,
                                maxLines: 3,
<<<<<<< HEAD
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
=======
>>>>>>> 80bcbd8 (hehe)
                                label: const Text("Description"),
                                hintText: "Description",
                                controller: description),
                          ),
<<<<<<< HEAD
                          ReusableText(
                              text: "Requirements",
                              style:
                                  appStyle(15, Colors.black, FontWeight.w600)),
=======
                          // Requirements
                          ReusableText(
                              text: "Requirements",
                              style: appStyle(15, Colors.black, FontWeight.w600)),
>>>>>>> 80bcbd8 (hehe)
                          const HeightSpacer(size: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
<<<<<<< HEAD
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
=======
                                label: const Text("Requirement 1"),
>>>>>>> 80bcbd8 (hehe)
                                hintText: "Requirements",
                                controller: rq1),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
<<<<<<< HEAD
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
=======
                                label: const Text("Requirement 2"),
>>>>>>> 80bcbd8 (hehe)
                                hintText: "Requirements",
                                controller: rq2),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
<<<<<<< HEAD
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
=======
                                label: const Text("Requirement 3"),
>>>>>>> 80bcbd8 (hehe)
                                hintText: "Requirements",
                                controller: rq3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
<<<<<<< HEAD
                                onSubmitted: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please fill the field");
                                  } else {
                                    return null;
                                  }
                                },
                                label: const Text("Requirements"),
=======
                                label: const Text("Requirement 4"),
>>>>>>> 80bcbd8 (hehe)
                                hintText: "Requirements",
                                controller: rq4),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildtextfield(
                                maxLines: 2,
                                height: 80,
<<<<<<< HEAD
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
                          CustomOutlineBtn(
                              width: width,
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String agentName =
                                    prefs.getString("username") ?? "";
=======
                                label: const Text("Requirement 5"),
                                hintText: "Requirements",
                                controller: rq5),
                          ),

                          // Accepted Disabilities section
                          ReusableText(
                              text: "Accepted Disabilities",
                              style: appStyle(15, Colors.black, FontWeight.w600)),
                          const HeightSpacer(size: 10),
                          buildtextfield(
                              label: const Text("Disability Type"),
                              hintText: "Type of Disability",
                              controller: disabilityType),
                          buildtextfield(
                              label: const Text("Specific Name"),
                              hintText: "e.g., Bulag, Bingi",
                              controller: specificName),
                          CustomOutlineBtn(
                            onTap: addDisability,
                            text: "Add Disability",
                            color: Color(kNewBlue.value),
                            hieght: 40.h,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: acceptedDisabilities.length,
                            itemBuilder: (context, index) {
                              final disability = acceptedDisabilities[index];
                              return ListTile(
                                title: Text(disability.type),
                                subtitle: Text(disability.specificNames.join(", ")),
                              );
                            },
                          ),

                          // Submit button
                          CustomOutlineBtn(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String agentName = prefs.getString("username") ?? "";
>>>>>>> 80bcbd8 (hehe)

                                CreateJobsRequest rawModel = CreateJobsRequest(
                                    title: title.text,
                                    location: location.text,
                                    company: company.text,
                                    hiring: jobUpdate!.hiring,
                                    description: description.text,
                                    salary: salary.text,
                                    period: period.text,
                                    contract: contract.text,
                                    imageUrl: skillsNotifier.logoUrl,
                                    agentId: jobUpdate!.agentId,
                                    requirements: [
                                      rq1.text,
                                      rq2.text,
                                      rq3.text,
                                      rq4.text,
                                      rq5.text,
                                    ],
<<<<<<< HEAD
                                    agentName: agentName);

                                var model = createJobsRequestToJson(rawModel);

=======
                                    agentName: agentName,
                                    acceptedDisabilities: acceptedDisabilities); // Include accepted disabilities

                                var model = createJobsRequestToJson(rawModel);
>>>>>>> 80bcbd8 (hehe)
                                JobsHelper.updateJob(model, jobUpdate!.id);
                                zoomNotifier.currentIndex = 0;
                                Get.to(() => const Mainscreen());
                              },
                              hieght: 40.h,
                              text: "Submit",
                              color: Color(kNewBlue.value))
                        ],
                      ),
<<<<<<< HEAD
                    )),
              ))
=======
                    ))),
          )
>>>>>>> 80bcbd8 (hehe)
        ],
      ),
    );
  }
}
