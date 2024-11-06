import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/agents_provider.dart';
import 'package:jobility/services/helpers/bookmark_provider.dart';
import 'package:jobility/controllers/image_provider.dart';
import 'package:jobility/controllers/jobs_provider.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/controllers/onboarding_provider.dart';
import 'package:jobility/controllers/profile_provider.dart';
import 'package:jobility/controllers/signup_provider.dart';
import 'package:jobility/controllers/skills_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/firebase_options.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:jobility/views/screens/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
Widget defaultHome = const OnboardingScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final entrypoint = prefs.getBool('entrypoint') ?? false;

  if (entrypoint == true) {
    defaultHome = const Mainscreen();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => OnBoardNotifier()),
    ChangeNotifierProvider(create: (context) => LoginNotifier()),
    ChangeNotifierProvider(create: (context) => ZoomNotifier()),
    ChangeNotifierProvider(create: (context) => SignUpNotifier()),
    ChangeNotifierProvider(create: (context) => JobsNotifier()),
    ChangeNotifierProvider(create: (context) => ImageUpoader()),
    ChangeNotifierProvider(create: (context) => ProfileNotifier()),
    ChangeNotifierProvider(create: (context) => BookNotifier()),
    ChangeNotifierProvider(create: (context) => SkillsNotifier()),
    ChangeNotifierProvider(create: (context) => AgentNotifier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Jobility',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(kLight.value),
              iconTheme: IconThemeData(color: Color(kDark.value)),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
          );
        });
  }
}

