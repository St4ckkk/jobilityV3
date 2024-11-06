import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/services/firebase_services.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/drawer/drawer_widget.dart';
import 'package:jobility/views/common/heading_widget.dart';
import 'package:jobility/views/common/search.dart';
import 'package:jobility/views/screens/auth/login.dart';
import 'package:jobility/views/screens/auth/profile_page.dart';
import 'package:jobility/views/screens/jobs/job_list_page.dart';
import 'package:jobility/views/screens/jobs/widgets/PopularJobs.dart';
import 'package:jobility/views/screens/jobs/widgets/Recentlist.dart';
import 'package:jobility/views/screens/search/search_page.dart';
import 'package:provider/provider.dart';

import '../../../controllers/profile_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServices services = FirebaseServices();
  String imageUrl =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    services.removeStatus(zoomNotifier, loginNotifier);
    loginNotifier.getPref();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
              actions: [
                Consumer<ProfileNotifier>(
                  builder: (context, profileNotifier, child) {
                    profileNotifier.getProfile();
                    return FutureBuilder(
                      future: profileNotifier.profile,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.all(12.h),
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage("assets/images/user.png"),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("error ${snapshot.error}");
                        } else {
                          var url = snapshot.data!.profile;
                          return Padding(
                            padding: EdgeInsets.all(12.h),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(url),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
              child: Padding(
                padding: EdgeInsets.all(12.0.h),
                child: DrawerWidget(color: Color(kDark.value)),
              ))),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search \n Find & Apply",
                style: appStyle(38, Color(kDark.value), FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              SearchWidget(
                onTap: () {
                  Get.to(() => const SearchPage());
                },
              ),
              SizedBox(height: 30.h),
              HeadingWidget(
                text: 'Popular Jobs',
                onTap: () {
                  Get.to(() => const JobListPage());
                },
              ),
              SizedBox(height: 15.h),
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.w)),
                  child: const PopularJobs()),
              SizedBox(height: 15.h),
              HeadingWidget(
                text: 'Recently Posted ',
                onTap: () {
                  Get.to(() => const JobListPage());
                },
              ),
              SizedBox(height: 15.h),
              const RecentJobs()
            ],
          ),
        ),
      )),
    );
  }
}
