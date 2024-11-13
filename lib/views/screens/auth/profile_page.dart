import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/models/response/auth/profile_model.dart';
import 'package:jobility/services/helpers/auth_helper.dart';
import 'package:jobility/views/common/BackBtn.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/drawer/drawer_widget.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/pages_loader.dart';
import 'package:jobility/views/common/styled_container.dart';
import 'package:jobility/views/common/width_spacer.dart';
import 'package:jobility/views/screens/auth/non_user.dart';
import 'package:jobility/views/screens/auth/widgets/edit_button.dart';
import 'package:jobility/views/screens/auth/widgets/skills.dart';
import 'package:jobility/views/screens/jobs/add_jobs.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:jobility/views/screens/auth/widgets/resume_preview.dart';
import 'edit_profile_page.dart';
import 'login.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.drawer});
  final bool drawer;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  ProfileRes? profile;
  bool isLoading = true;
  bool isPreviewLoading = false; // New state variable
  String defaultImage = "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

  @override
  void initState() {
    super.initState();
    initializeProfile();
  }

  Future<void> initializeProfile() async {
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    if (!loginNotifier.loggedIn) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final profileData = await AuthHelper.getProfile();
      setState(() {
        profile = profileData;
        isLoading = false;
      });

      // Store agentId in SharedPreferences if the user is an agent
      if (profileData.isAgent) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('agentId', profileData.id);
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleResumeUpload() async {
    setState(() { isLoading = true; }); // Start loading

    bool uploadResult = await AuthHelper.uploadResume();
    if (uploadResult) {
      Get.snackbar("Success", "Resume uploaded successfully", backgroundColor: Colors.green, colorText: Colors.white);
      await initializeProfile();
    } else {
      Get.snackbar("Error", "Failed to upload resume", backgroundColor: Colors.red, colorText: Colors.white);
    }

    setState(() { isLoading = false; }); // End loading
  }

  Widget buildProfileHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
          color: Color(kLightBlue.value)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularAvata(
                  image: profile?.profile ?? defaultImage,
                  w: 50,
                  h: 50
              ),
              const WidthSpacer(width: 20),
              SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white30
                      ),
                      child: ReusableText(
                          text: profile?.email ?? "Loading...",
                          style: appStyle(14, Color(kLight.value), FontWeight.w400)
                      ),
                    ),
                    SizedBox(height: 5.h),
                    ReusableText(
                      text: profile?.name ?? "Loading...",
                      style: appStyle(12, Color(kLight.value), FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _handleEditProfile(),
            child: Padding(
              padding: EdgeInsets.only(top: 10.0.w),
              child: Tooltip(
                message: 'Edit Profile', // Tooltip message for better accessibility
                child: Icon(
                  Feather.edit,
                  color: Color(kLight.value),
                  semanticLabel: 'Edit Profile', // Accessibility label
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProfileContent() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        buildProfileCompletionMessage(), // Add profile completion message at the top
        const HeightSpacer(size: 30),
        ReusableText(
            text: 'Profile',
            style: appStyle(15, Color(kDark.value), FontWeight.w600)
        ),
        const HeightSpacer(size: 10),
        buildResumeSection(),
        const HeightSpacer(size: 20),
        const SkillsWidget(),
        const HeightSpacer(size: 20),
        buildEducationSection(), // Add education section
        const HeightSpacer(size: 20),
        buildExperienceSection(), // Add experience section
        const HeightSpacer(size: 20),
        buildDisabilitySection(), // Add disability section
        const HeightSpacer(size: 20),
        buildAgentSection(),
        const HeightSpacer(size: 20),
        buildLogoutButton(),
        const HeightSpacer(size: 20),
      ],
    );
  }

  Widget buildProfileCompletionMessage() {
    int missingDetails = 0;
    if (profile?.resume == null) missingDetails++;
    if (profile?.education == null || profile!.education!.isEmpty) missingDetails++;
    if (profile?.experience == null || profile!.experience!.isEmpty) missingDetails++;

    if (missingDetails >= 1) {
      return Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(color: Colors.blue, width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
                text: 'Complete your profile to get the most out of our platform',
                style: appStyle(16, Colors.blue[900]!, FontWeight.bold)
            ),
            const HeightSpacer(size: 10),
            LinearProgressIndicator(
              value: (3 - missingDetails) / 3,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const HeightSpacer(size: 10),
            ReusableText(
                text: 'Add the missing details to complete your profile.',
                style: appStyle(14, Colors.blue[900]!, FontWeight.w400)
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildResumeSection() {
    return Stack(
      children: [
        Container(
          width: width,
          height: hieght * 0.12,
          decoration: BoxDecoration(
              color: Color(kLightGrey.value),
              borderRadius: const BorderRadius.all(Radius.circular(12))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 12.w),
                width: 60.w,
                height: 70.h,
                decoration: BoxDecoration(
                    color: Color(kLight.value),
                    borderRadius: const BorderRadius.all(Radius.circular(12))
                ),
                child: const Icon(
                    FontAwesome5Regular.file_pdf,
                    color: Colors.red,
                    size: 40
                ),
              ),
              const WidthSpacer(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText(
                      text: "Your Resume",
                      style: appStyle(16, Color(kDark.value), FontWeight.w500)
                  ),
                  Text(
                      profile?.resume != null
                          ? "Click to preview your resume"
                          : "Upload your resume (PDF format)",
                      style: appStyle(8, Color(kDarkGrey.value), FontWeight.w500)
                  ),
                ],
              ),
            ],
          ),
        ),
        // Make the entire container clickable for preview
        if (profile?.resume != null)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  setState(() { isPreviewLoading = true; }); // Start loading
                  try {
                    String? base64Resume = await AuthHelper.getResume(profile!.id);
                    if (base64Resume != null) {
                      File resumeFile = await fetchAndDecodeResume(base64Resume);
                      openPDFViewer(context, resumeFile);
                    } else {
                      Get.snackbar(
                          "Error",
                          "Failed to fetch resume",
                          backgroundColor: Colors.red,
                          colorText: Colors.white
                      );
                    }
                  } catch (e) {
                    print('Error fetching resume: $e');
                    Get.snackbar(
                        "Error",
                        "Failed to fetch resume",
                        backgroundColor: Colors.red,
                        colorText: Colors.white
                    );
                  } finally {
                    setState(() { isPreviewLoading = false; }); // End loading
                  }
                },
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        // Edit/Upload button
        Positioned(
          right: 0.w,
          child: EditButton(
              onTap: () async {
                await _handleResumeUpload();
                // Refresh profile after upload
                await initializeProfile();
              }
          ),
        ),
        // Loader
        if (isPreviewLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  Widget buildEducationSection() {
    if (profile?.education != null && profile!.education!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: 'Education',
              style: appStyle(18, Color(kDark.value), FontWeight.bold)
          ),
          const HeightSpacer(size: 10),
          ...profile!.education!.map((education) => buildCard(
            title: education.institution,
            subtitle: education.degree,
            description: education.fieldOfStudy,
            date: "${formatDate(education.startDate)} - ${formatDate(education.endDate)}",
          )).toList(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: 'Education',
              style: appStyle(18, Color(kDark.value), FontWeight.bold)
          ),
          const HeightSpacer(size: 10),
          ReusableText(
              text: 'No education details available.',
              style: appStyle(14, Color(kDarkGrey.value), FontWeight.w400)
          ),
        ],
      );
    }
  }

  Widget buildExperienceSection() {
    if (profile?.experience != null && profile!.experience!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: 'Experience',
              style: appStyle(18, Color(kDark.value), FontWeight.bold)
          ),
          const HeightSpacer(size: 10),
          ...profile!.experience!.map((experience) => buildCard(
            title: experience.company,
            subtitle: experience.position,
            description: experience.description ?? '',
            date: "${formatDate(experience.startDate)} - ${formatDate(experience.endDate)}",
          )).toList(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: 'Experience',
              style: appStyle(18, Color(kDark.value), FontWeight.bold)
          ),
          const HeightSpacer(size: 10),
          ReusableText(
              text: 'No experience details available.',
              style: appStyle(14, Color(kDarkGrey.value), FontWeight.w400)
          ),
        ],
      );
    }
  }

  Widget buildCard({required String title, required String subtitle, required String description, required String date}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
          color: Color(kLightGrey.value),
          borderRadius: const BorderRadius.all(Radius.circular(12))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: title,
            style: appStyle(16, Color(kDark.value), FontWeight.bold),
          ),
          const HeightSpacer(size: 5),
          ReusableText(
            text: subtitle,
            style: appStyle(14, Color(kDarkGrey.value), FontWeight.w600),
          ),
          const HeightSpacer(size: 5),
          ReusableText(
            text: description,
            style: appStyle(14, Color(kDarkGrey.value), FontWeight.w400),
          ),
          const HeightSpacer(size: 5),
          ReusableText(
            text: date,
            style: appStyle(12, Color(kDarkGrey.value), FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget buildDisabilitySection() {
    if (profile?.disability != null && profile!.disability!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: 'Disability Information',
              style: appStyle(14, Color(kDark.value), FontWeight.w600)
          ),
          const HeightSpacer(size: 10),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
                color: Color(kLightGrey.value),
                borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: ReusableText(
              text: profile!.disability!,
              style: appStyle(12, Color(kDark.value), FontWeight.w400),
            ),
          ),
          const HeightSpacer(size: 10),
          if (profile?.pwdIdImage != null && profile!.pwdIdImage!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: 'PWD ID Card',
                  style: appStyle(15, Color(kDark.value), FontWeight.w600),
                ),
                const HeightSpacer(size: 10),
                Container(
                  width: 350.w, // Increased width
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: Image.file(
                      File(profile!.pwdIdImage!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildAgentSection() {
    if (profile?.isAgent ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: 'Agent Section',
              style: appStyle(14, Color(kDark.value), FontWeight.w600)
          ),
          const HeightSpacer(size: 20),
          CustomOutlineBtn(
              width: width,
              onTap: () {
                Get.to(() => const AddJobs());
              },
              hieght: 40.h,
              text: "Add Jobs",
              color: Color(kNewBlue.value)
          ),
          const HeightSpacer(size: 10),
          CustomOutlineBtn(
              width: width,
              onTap: () {},
              hieght: 40.h,
              text: "Update Information",
              color: Color(kNewBlue.value)
          ),
        ],
      );
    } else {
      return CustomOutlineBtn(
          width: width,
          onTap: () {},
          hieght: 40.h,
          text: "Apply to become an agent",
          color: Color(kNewBlue.value)
      );
    }
  }

  Widget buildLogoutButton() {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);

    return CustomOutlineBtn(
      width: width,
      onTap: () {
        // Show confirmation snackbar before logout
        Get.snackbar(
          "Logged Out",
          "You have been successfully logged out.",
          colorText: Color(kDark.value),
          backgroundColor: Color(kGreen.value), // Use a success color
          icon: const Icon(Icons.check_circle),
        );

        // Proceed to logout
        zoomNotifier.currentIndex = 0;
        loginNotifier.logout();

        // Navigate to LoginPage after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const LoginPage());
        });
      },
      hieght: 40.h,
      text: "Proceed to logout",
      color: Color(kNewBlue.value),
    );
  }

  Future<void> _handleEditProfile() async {
    // Navigate to EditProfilePage
    Get.to(() => const EditProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);

    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          color: Color(kNewBlue.value),
          text: profile?.username?.toUpperCase() ?? '',
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: widget.drawer == false
                ? const BackBtn()
                : DrawerWidget(color: Color(kLight.value)),
          ),
        ),
      ),
      body: loginNotifier.loggedIn == false
          ? const NonUser()
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            top: 0,
            child: buildProfileHeader(),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            top: 90.h,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                  ),
                  color: Color(kLight.value)
              ),
              child: buildStyleContainer(
                context,
                buildProfileContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CircularAvata extends StatelessWidget {
  const CircularAvata({
    super.key,
    required this.image,
    required this.w,
    required this.h
  });

  final String image;
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    bool isLocalFile = image.startsWith('/');

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(99.w)),
      child: isLocalFile
          ? Image.file(
        File(image),
        width: w,
        height: h,
        fit: BoxFit.cover,
      )
          : CachedNetworkImage(
        imageUrl: image,
        width: w,
        height: h,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}