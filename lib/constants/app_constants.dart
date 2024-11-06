import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/models/response/jobs/get_job.dart';

const kDark = Color(0xFF000000);
const kLight = Color(0xFFFFFFFF);
const kLightGrey = Color(0x45D1CECE);
const kDarkGrey = Color(0xFF9B9B9B);
const kOrange = Color(0xfff55631);
const kLightBlue = Color(0xFF0078FF);
const kDarkBlue = Color(0xff1c153e);
const kLightPurple = Color(0xff6352c5);
const kDarkPurple = Color(0xff6352c5);
const kNewBlue = Color(0xFF3281E3);
const kBlueTrans = Color(0x3B3282E3);
const kGreen = Color(0xFFEFFFFC);

double hieght = 812.h;
double width = 375.w;

String theId = "";

List<String> requirements = [
  "Design and Build sophisticated and highly scalable apps using Flutter.",
  "Build custom packages in Flutter using the functionalities and APIs already available in native Android and IOS.",
  "Translate and Build the designs and Wireframes into high quality responsive UI code.",
  "Explore feasible architectures for implementing new features.",
  "Resolve any problems existing in the system and suggest and add new features in the complete system.",
  "Suggest space and time efficient Data Structures.",
];

String desc =
    "Flutter Developer is responsible for running and designing product application features across multiple devices across platforms. Flutter is Google's UI toolkit for building beautiful, natively compiled apps for mobile, web, and desktop from a single codebase. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.";

List<String> skills = [

  
  "Node JS",
  "Java SpringBoot",
  "Flutter and Dart",
  "Firebase",
  "AWS",
];

// List<String> profile = [];

String username = '';
String name = '';
String userUid = '';
String profile = '';

GetJobRes? jobUpdate;
