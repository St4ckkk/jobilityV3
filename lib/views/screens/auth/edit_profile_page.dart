import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/models/response/auth/profile_model.dart';
import 'package:jobility/services/helpers/auth_helper.dart';
import 'package:jobility/views/common/BackBtn.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/width_spacer.dart';
import 'package:jobility/views/screens/auth/widgets/skills.dart';
import '../../../models/request/auth/update_user_profile.dart'; // Import the ProfileUpdate class

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = true;
  ProfileRes? profile;
  String defaultImage = "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

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

  Future<void> _handleImageUpload() async {
    // Implement image upload functionality
    // After upload, refresh the profile
    await initializeProfile();
  }

  Future<void> _handleSave() async {
    setState(() {
      isLoading = true;
    });

    try {
      ProfileUpdate profileUpdate = ProfileUpdate(
        id: profile?.id ?? '',
        username: _usernameController.text,
        name: _nameController.text,
        email: _emailController.text,
        skills: [], // Keep the existing skills
        profile: profile?.profile ?? defaultImage, // Change profileImage to profile
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
                    child: CachedNetworkImage(
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
                      Container(
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
                          child: profile!.pwdIdImage!.startsWith('http')
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