import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobility/models/response/auth/profile_model.dart' as response; // Alias for response models
import 'package:jobility/services/helpers/auth_helper.dart';
import 'package:jobility/views/common/BackBtn.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/width_spacer.dart';
import 'package:jobility/views/screens/auth/widgets/skills.dart';
import '../../../models/request/auth/update_user_profile.dart' as request; // Alias for request models



class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<request.Education> _educationList = [];
  final List<request.Experience> _experienceList = [];
  bool isLoading = true;
  response.ProfileRes? profile;
  String defaultImage = "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";
  XFile? pwdIdImage;
  XFile? profileImage;
  bool _uploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    initializeProfile();
  }

  Future<void> initializeProfile() async {
    try {
      final profileData = await AuthHelper.getProfile();
      setState(() {
        profile = profileData;
        _usernameController.text = profile?.username ?? '';
        _nameController.text = profile?.name ?? '';
        _emailController.text = profile?.email ?? '';
        _educationList.clear();
        _experienceList.clear();
        _educationList.addAll(profile?.education?.map((e) => request.Education(
          institution: e.institution,
          degree: e.degree,
          fieldOfStudy: e.fieldOfStudy,
          startDate: e.startDate.toIso8601String(),
          endDate: e.endDate.toIso8601String(),
        )) ?? []);
        _experienceList.addAll(profile?.experience?.map((e) => request.Experience(
          company: e.company,
          position: e.position,
          startDate: e.startDate.toIso8601String(),
          endDate: e.endDate.toIso8601String(),
          description: e.description,
        )) ?? []);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> pickImage(bool isProfileImage) async {
    try {
      setState(() {
        _uploading = true;
        _errorMessage = null;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (isProfileImage) {
            profileImage = pickedFile;
          } else {
            pwdIdImage = pickedFile;
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to upload image. Please try again.';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _handleImageUpload() async {
    await pickImage(true);
    await initializeProfile();
  }

  Future<void> _handlePwdIdUpload() async {
    await pickImage(false);
    await initializeProfile();
  }

  Future<void> _handleSave() async {
    setState(() {
      isLoading = true;
    });

    try {
      request.ProfileUpdate profileUpdate = request.ProfileUpdate(
        id: profile?.id ?? '',
        username: _usernameController.text,
        name: _nameController.text,
        email: _emailController.text,
        skills: profile?.skills.map((skill) => skill.toString()).toList() ?? [],
        profile: profileImage?.path ?? profile?.profile ?? defaultImage,
        pwdIdImage: pwdIdImage?.path ?? profile?.pwdIdImage ?? '',
        education: _educationList,
        experience: _experienceList,
      );

      bool success = await AuthHelper.updateProfile(profileUpdate);

      if (success) {
        Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to update profile", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addEducation() {
    setState(() {
      _educationList.add(request.Education(
        institution: '',
        degree: '',
        fieldOfStudy: '',
        startDate: '',
        endDate: '',
      ));
    });
  }

  void _addExperience() {
    setState(() {
      _experienceList.add(request.Experience(
        company: '',
        position: '',
        startDate: '',
        endDate: '',
        description: '',
      ));
    });
  }

  Future<void> _selectDate(BuildContext context, int index, bool isEducation, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    try {
      if (isEducation) {
        initialDate = isStartDate
            ? DateTime.parse(_educationList[index].startDate)
            : DateTime.parse(_educationList[index].endDate);
      } else {
        initialDate = isStartDate
            ? DateTime.parse(_experienceList[index].startDate)
            : DateTime.parse(_experienceList[index].endDate);
      }
    } catch (e) {

      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        String formattedDate = picked.toIso8601String();
        if (isEducation) {
          if (isStartDate) {
            _educationList[index].startDate = formattedDate;
          } else {
            _educationList[index].endDate = formattedDate;
          }
        } else {
          if (isStartDate) {
            _experienceList[index].startDate = formattedDate;
          } else {
            _experienceList[index].endDate = formattedDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          color: Color(kNewBlue.value),
          text: 'EDIT PROFILE',
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const BackBtn(),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Color(kLight.value),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              const HeightSpacer(size: 30),
              ReusableText(
                text: 'Edit Profile',
                style: appStyle(15, Color(kDark.value), FontWeight.w600),
              ),
              const HeightSpacer(size: 20),
              GestureDetector(
                onTap: _handleImageUpload,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(99.w)),
                    child: profileImage != null
                        ? Image.file(
                      File(profileImage!.path),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    )
                        : profile?.profile != null && profile!.profile!.startsWith('/')
                        ? Image.file(
                      File(profile!.profile!),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      imageUrl: profile?.profile ?? defaultImage,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              const HeightSpacer(size: 20),
              if (profile?.pwdIdImage != null && profile!.pwdIdImage!.isNotEmpty)
                Center(
                  child: Column(
                    children: [
                      ReusableText(
                        text: 'PWD ID Card',
                        style: appStyle(15, Color(kDark.value), FontWeight.w600),
                      ),
                      const HeightSpacer(size: 10),
                      GestureDetector(
                        onTap: _handlePwdIdUpload,
                        child: Container(
                          width: 300.w,
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
                            child: pwdIdImage != null
                                ? Image.file(
                              File(pwdIdImage!.path),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : profile!.pwdIdImage!.startsWith('http')
                                ? CachedNetworkImage(
                              imageUrl: profile!.pwdIdImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                                : Image.file(
                              File(profile!.pwdIdImage!),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const HeightSpacer(size: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const HeightSpacer(size: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const HeightSpacer(size: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const HeightSpacer(size: 20),
              const SkillsWidget(), // Keep the existing skills
              const HeightSpacer(size: 20),
              ReusableText(
                text: 'Education',
                style: appStyle(15, Color(kDark.value), FontWeight.w600),
              ),
              const HeightSpacer(size: 10),
              ..._educationList.map((education) {
                int index = _educationList.indexOf(education);
                return Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Institution',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _educationList[index].institution = value;
                      },
                      controller: TextEditingController(text: education.institution),
                    ),
                    const HeightSpacer(size: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Degree',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _educationList[index].degree = value;
                      },
                      controller: TextEditingController(text: education.degree),
                    ),
                    const HeightSpacer(size: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Field of Study',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _educationList[index].fieldOfStudy = value;
                      },
                      controller: TextEditingController(text: education.fieldOfStudy),
                    ),
                    const HeightSpacer(size: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, index, true, true),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: TextEditingController(
                            text: _educationList[index].startDate.split('T')[0],
                          ),
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, index, true, false),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: TextEditingController(
                            text: _educationList[index].endDate.split('T')[0],
                          ),
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 20),
                  ],
                );
              }).toList(),
              CustomOutlineBtn(
                width: double.infinity,
                onTap: _addEducation,
                hieght: 40.h,
                text: "Add Education",
                color: Color(kNewBlue.value),
              ),
              const HeightSpacer(size: 20),
              ReusableText(
                text: 'Experience',
                style: appStyle(15, Color(kDark.value), FontWeight.w600),
              ),
              const HeightSpacer(size: 10),
              ..._experienceList.map((experience) {
                int index = _experienceList.indexOf(experience);
                return Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Company',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _experienceList[index].company = value;
                      },
                      controller: TextEditingController(text: experience.company),
                    ),
                    const HeightSpacer(size: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _experienceList[index].position = value;
                      },
                      controller: TextEditingController(text: experience.position),
                    ),
                    const HeightSpacer(size: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _experienceList[index].description = value;
                      },
                      controller: TextEditingController(text: experience.description),
                    ),
                    const HeightSpacer(size: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, index, false, true),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: TextEditingController(
                            text: _experienceList[index].startDate.split('T')[0],
                          ),
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, index, false, false),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: TextEditingController(
                            text: _experienceList[index].endDate.split('T')[0],
                          ),
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 20),
                  ],
                );
              }).toList(),
              CustomOutlineBtn(
                width: double.infinity,
                onTap: _addExperience,
                hieght: 40.h,
                text: "Add Experience",
                color: Color(kNewBlue.value),
              ),
              const HeightSpacer(size: 20),
              CustomOutlineBtn(
                width: double.infinity,
                onTap: _handleSave,
                hieght: 40.h,
                text: "Save",
                color: Color(kNewBlue.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}