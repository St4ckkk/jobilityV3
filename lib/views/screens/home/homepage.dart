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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobility/services/helpers/jobs_helper.dart';

import 'package:jobility/controllers/jobs_provider.dart';

import '../../../controllers/profile_provider.dart';
import '../../../models/response/jobs/get_jobAlerts.dart';
import '../jobs/job_details_page.dart';
import '../jobs/widgets/view_all_job_alerts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  FirebaseServices services = FirebaseServices();
  String imageUrl =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b5065bb8-4c6b-4eac-a0ce-86ab0f597b1e-vinci_04.jpg";

  List<JobAlert> jobAlerts = [];
  late AnimationController _controller;
  late Animation<Color?> _colorTween;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
      loginNotifier.getPref();
      _fetchJobAlerts();
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorTween = ColorTween(begin: Colors.red, end: Colors.red[300]).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchJobAlerts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      try {
        print('Fetching job alerts for user ID: $userId');
        List<JobAlert> alerts = await JobsHelper.getJobAlerts(userId);
        setState(() {
          jobAlerts = alerts;
        });

        // Automatically remove notifications after one hour
        Future.delayed(Duration(hours: 1), () {
          setState(() {
            jobAlerts.clear();
          });
        });
      } catch (e) {
        print('Error fetching job alerts: $e');
      }
    }
  }

  void _dismissNotification(JobAlert alert) {
    setState(() {
      jobAlerts.remove(alert);
    });
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    services.removeStatus(zoomNotifier, loginNotifier);

    // Debugging statement
    print('HomePage: userUid in build: ${loginNotifier.userUid}');

    if (loginNotifier.userUid.isEmpty) {
      print('Error: userUid is empty or null in HomePage');
    }

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
                    "Search \nFind & Apply",
                    style: appStyle(38, Color(kDark.value), FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  SearchWidget(
                    onTap: () {
                      Get.to(() => const SearchPage());
                    },
                  ),
                  SizedBox(height: 30.h),
                  if (jobAlerts.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: jobAlerts.length > 3 ? 3 : jobAlerts.length,
                      itemBuilder: (context, index) {
                        var alert = jobAlerts[index];
                        return Dismissible(
                          key: Key(alert.id),
                          onDismissed: (direction) {
                            _dismissNotification(alert);
                          },
                          child: Card(
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Get.to(() => JobDetails(
                                    title: alert.jobId.title,
                                    id: alert.jobId.id,
                                    company: alert.jobId.company,
                                  ));
                                },
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(alert.jobId.imageUrl),
                                  radius: 20,
                                ),
                              ),
                              title: Row(
                                children: [
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      return Text(
                                        'New Job Alert',
                                        style: appStyle(14, _colorTween.value!, FontWeight.bold),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'A new job that matches your profile has been posted: ${alert.jobId.company}',
                                style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.close, color: Colors.red, size: 20),
                                onPressed: () {
                                  _dismissNotification(alert);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (jobAlerts.length > 3)
                    TextButton(
                      onPressed: () {
                        Get.to(() => ViewAllJobAlerts(jobAlerts: jobAlerts));
                      },
                      child: Text(
                        'View all Job alerts',
                        style: TextStyle(fontSize: 18.0), // Adjust the font size here
                      ),
                    ),
                  SizedBox(height: 20.h),
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
                    text: 'Recently Posted',
                    onTap: () {
                      Get.to(() => const JobListPage());
                    },
                  ),
                  SizedBox(height: 15.h),
                  const RecentJobs(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          )),
    );
  }
}