import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/signup_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/models/request/auth/signup_model.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_btn.dart';
import 'package:jobility/views/common/custom_textfield.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/pages_loader.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/common/styled_container.dart';
import 'package:jobility/views/screens/auth/login.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController disability = TextEditingController();
  XFile? pwdIdImage;
  bool _uploading = false;
  String? _errorMessage;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    username.dispose();
    disability.dispose();
    super.dispose();
  }

  Future<void> pickPwdId() async {
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
          pwdIdImage = pickedFile;
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

  Widget _buildPwdIdPreview() {
    if (pwdIdImage == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'No PWD ID uploaded yet',
                style: appStyle(14, Color(kDarkGrey.value), FontWeight.w400),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(pwdIdImage!.path),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: pickPwdId,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                'PWD ID Preview',
                style: appStyle(12, Colors.white, FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pwdIdImage == null)
          ElevatedButton(
            onPressed: _uploading ? null : pickPwdId,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Color(kLightBlue.value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _uploading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Uploading...',
                  style: appStyle(14, Colors.white, FontWeight.w500),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upload_file, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Upload PWD ID',
                  style: appStyle(14, Colors.white, FontWeight.w500),
                ),
              ],
            ),
          ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _errorMessage!,
              style: appStyle(12, Colors.red, FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              text: 'Sign Up',
              child: GestureDetector(
                onTap: () {
                  Get.offAll(() => const LoginPage());
                },
                child: const Icon(AntDesign.leftcircleo),
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/registration-cover.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              signUpNotifier.loader
                  ? const PageLoader()
                  : buildStyleContainer(
                context,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const HeightSpacer(size: 50),
                        ReusableText(
                          text: "Welcome",
                          style: appStyle(30, Color(kDark.value), FontWeight.w600),
                        ),
                        ReusableText(
                          text: "Fill in the Details to sign up for a new account.",
                          style: appStyle(14, Color(kDarkGrey.value), FontWeight.w400),
                        ),
                        const HeightSpacer(size: 40),
                        CustomTextField(
                          controller: name,
                          hintText: "Full name",
                          keyboardType: TextInputType.text,
                          validator: (name) {
                            if (name!.isEmpty) {
                              return "Please enter your full name";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 20),
                        CustomTextField(
                          controller: username,
                          hintText: "Username",
                          keyboardType: TextInputType.text,
                          validator: (username) {
                            if (username!.isEmpty) {
                              return "Please enter your username";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 20),
                        CustomTextField(
                          controller: email,
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email!.isEmpty || !email.contains('@')) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 20),
                        CustomTextField(
                          controller: password,
                          hintText: "Password",
                          obscureText: signUpNotifier.obscureText,
                          keyboardType: TextInputType.text,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signUpNotifier.obscureText = !signUpNotifier.obscureText;
                            },
                            child: Icon(
                              signUpNotifier.obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          validator: (password) {
                            if (password!.length < 8) {
                              return "Password should be at least 8 characters long";
                            }
                            return null;
                          },
                        ),
                        const HeightSpacer(size: 20),
                        CustomTextField(
                          controller: disability,
                          hintText: "Disability (if any)",
                          keyboardType: TextInputType.text,
                        ),
                        const HeightSpacer(size: 20),
                        _buildPwdIdPreview(),
                        const HeightSpacer(size: 12),
                        _buildUploadButton(),
                        const HeightSpacer(size: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.offAll(() => const LoginPage());
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Already have an account? ",
                                    style: appStyle(12, Color(kDark.value), FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: "Login",
                                    style: appStyle(12, Color(kLightBlue.value), FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const HeightSpacer(size: 30),
                        Consumer<ZoomNotifier>(
                          builder: (context, zoomNotifier, child) {
                            return CustomButton(
                              text: "Sign Up",
                              onTap: () {
                                signUpNotifier.loader = true;

                                SignupModel model = SignupModel(
                                  name: name.text,
                                  username: username.text,
                                  email: email.text,
                                  password: password.text,
                                  disability: disability.text,
                                  pwdIdImage: pwdIdImage?.path,
                                );

                                String newModel = signupModelToJson(model);
                                signUpNotifier.signUp(newModel);
                              },
                            );
                          },
                        ),
                        const HeightSpacer(size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}