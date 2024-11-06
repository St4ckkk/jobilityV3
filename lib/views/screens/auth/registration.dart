import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  @override
  void dispose() {

    email.dispose();
    password.dispose();
    name.dispose();
    username.dispose();
    super.dispose();
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
                child: const Icon(
                  AntDesign.leftcircleo,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              // Background image
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/registration-cover.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Main content on top of the background
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
                          style: appStyle(
                              30, Color(kDark.value), FontWeight.w600),
                        ),
                        ReusableText(
                          text:
                          "Fill in the Details to sign up for a new account.",
                          style: appStyle(
                              14, Color(kDarkGrey.value), FontWeight.w400),
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
                              signUpNotifier.obscureText =
                              !signUpNotifier.obscureText;
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
                        const HeightSpacer(size: 10),
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
                                    style: appStyle(
                                        12, Color(kDark.value), FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: "Login",
                                    style: appStyle(
                                        12, Color(kLightBlue.value), FontWeight.bold),
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
                                    password: password.text);

                                String newModel = signupModelToJson(model);

                                signUpNotifier.signUp(newModel);
                              },
                            );
                          },
                        ),
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
