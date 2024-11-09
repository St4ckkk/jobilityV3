import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/services/helpers/bookmark_provider.dart';
import 'package:jobility/controllers/jobs_provider.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:jobility/models/request/applied/applied.dart';
import 'package:jobility/models/response/bookmarks/book_res.dart';
import 'package:jobility/models/response/jobs/get_job.dart';
import 'package:jobility/models/response/jobs/get_review.dart';
import 'package:jobility/services/firebase_services.dart';
import 'package:jobility/services/helpers/applied_helper.dart';
import 'package:jobility/services/helpers/jobs_helper.dart';
import 'package:jobility/services/helpers/review_helper.dart';
import 'package:jobility/views/common/BackBtn.dart';
import 'package:jobility/views/common/app_bar.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/custom_outline_btn.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/pages_loader.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/common/styled_container.dart';
import 'package:jobility/views/screens/jobs/update_job.dart';
import 'package:jobility/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../models/request/jobs/create_review.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({
    super.key,
    required this.title,
    required this.id,
    required this.agentName,
  });

  final String title;
  final String id;
  final String agentName;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> with SingleTickerProviderStateMixin {
  FirebaseServices services = FirebaseServices();
  late Future<GetJobRes> job;
  late Future<List<Review>> reviews;
  bool isAgent = false;
  late TabController _tabController;
  int _selectedTabIndex = 0;
  double _rating = 0.0;
  TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    getJob();
    getReviews();
    getPrefs();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  getReviews() {
    // Fetch all reviews associated with the job
    reviews = JobsNotifier().getReviewsForJob(widget.id);
  }

  getJob() {
    job = JobsHelper.getJob(widget.id);
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAgent = prefs.getBool('isAgent') ?? false;
  }

  createChat(Map<String, dynamic> jobDetails, List<String> users, String chatRoomId, String messageType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('uid');
    String name = prefs.getString('name') ?? 'Anonymous';
    String profile = prefs.getString('profile') ?? '';

    if (userUid == null || userUid.isEmpty) {
      print('Error: User UID is empty or not found');
      return;
    }

    Map<String, dynamic> chatData = {
      'agentName': widget.agentName,
      'chatRoomId': chatRoomId,
      'job': jobDetails,
      'company': jobDetails['company'],
      'image_url': jobDetails['image_url'],
      'job_id': jobDetails['job_id'],
      'salary': jobDetails['salary'],
      'title': jobDetails['title'],
      'lastChat': "Good Day, Sir! I'm interested in this job.",
      'lastChatTime': Timestamp.now(),
      'messageType': messageType,
      'name': name,
      'profile': profile,
      'read': false,
      'sender': userUid,
      'users': users,
    };

    print('Creating chat room with data: $chatData');
    services.createChatRoom(chatData);
  }

  Widget _buildCompanyTab(GetJobRes job) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: job.company,
            style: appStyle(18, Color(kDark.value), FontWeight.bold),
          ),
          const HeightSpacer(size: 10),
          Text(
            "Location: ${job.location}",
            style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
          ),
          const HeightSpacer(size: 10),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: FutureBuilder<List<Review>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No reviews available yet",
                style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
              ),
            );
          } else {
            final reviewsList = snapshot.data!;
            return ListView.builder(
              itemCount: reviewsList.length,
              itemBuilder: (context, index) {
                Review review = reviewsList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.w,
                            backgroundImage: NetworkImage(review.reviewerId.profile),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                text: review.reviewerId.name,
                                style: appStyle(16, Color(kDark.value), FontWeight.bold),
                              ),
                              RatingBarIndicator(
                                rating: review.rating.toDouble(),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const HeightSpacer(size: 10),
                      Text(
                        review.comment,
                        style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAddReviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const HeightSpacer(size: 10),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Write your review',
                ),
                maxLines: 3,
              ),
              const HeightSpacer(size: 10),
              CustomOutlineBtn(
                text: "Add Review",
                hieght: 50.h,
                onTap: () {
                  _addReview();
                  Navigator.pop(context);
                },
                color: Color(kLight.value),
                color2: Color(kLightBlue.value),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addReview() async {
    if (_rating == 0.0 || _reviewController.text.isEmpty) {
      // Show error message
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      // Show error message
      return;
    }

    CreateReview newReview = CreateReview(
      reviewerId: userId,
      jobId: widget.id,
      rating: _rating.toInt(),
      comment: _reviewController.text,
      id: '',
      createdAt: DateTime.now(),
    );

    // Call the create review method
    bool success = await ReviewsHelper.createReview(newReview);

    if (success) {
      // Clear the form
      setState(() {
        _rating = 0.0;
        _reviewController.clear();
      });

      // Refresh the reviews
      getReviews();
    } else {
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    var zoomNotifier = Provider.of<ZoomNotifier>(context);

    return Consumer<JobsNotifier>(builder: (context, jobsNotifier, child) {
      jobsNotifier.getJob(widget.id);
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            actions: [
              loginNotifier.loggedIn != false
                  ? Consumer<BookNotifier>(
                builder: (context, bookNotifier, child) {
                  bookNotifier.getBookMark(widget.id);
                  return GestureDetector(
                    onTap: () {
                      if (bookNotifier.bookmark == true) {
                        bookNotifier.deleteBookMark(bookNotifier.bookmarkId);
                      } else {
                        BookMarkReqRes model = BookMarkReqRes(job: widget.id);
                        var newModel = bookMarkReqResToJson(model);
                        bookNotifier.addBookMark(newModel);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Icon(
                        bookNotifier.bookmark == false
                            ? Fontisto.bookmark
                            : Fontisto.bookmark_alt,
                      ),
                    ),
                  );
                },
              )
                  : const SizedBox.shrink()
            ],
            child: const BackBtn(),
          ),
        ),
        body: buildStyleContainer(
          context,
          FutureBuilder<GetJobRes>(
            future: job,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PageLoader();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final job = snapshot.data;

                return Stack(
                  children: [
                    Column(
                      children: [
                        // Job Header
                        Container(
                          width: width,
                          height: hieght * 0.27,
                          decoration: BoxDecoration(
                            color: Color(kLightGrey.value),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/page-3.png'),
                              opacity: 0.50,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(9.w)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30.w,
                                backgroundImage: NetworkImage(job!.imageUrl),
                              ),
                              const HeightSpacer(size: 10),
                              ReusableText(
                                text: job.title,
                                style: appStyle(16, Color(kDark.value), FontWeight.w600),
                              ),
                              const HeightSpacer(size: 5),
                              ReusableText(
                                text: job.location,
                                style: appStyle(16, Color(kDarkGrey.value), FontWeight.w600),
                              ),
                              const HeightSpacer(size: 15),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomOutlineBtn(
                                      width: width * .26,
                                      hieght: hieght * .04,
                                      text: job.contract,
                                      color: Color(kLightBlue.value),
                                    ),
                                    Row(
                                      children: [
                                        ReusableText(
                                          text: job.salary,
                                          style: appStyle(16, Color(kDark.value), FontWeight.w600),
                                        ),
                                        ReusableText(
                                          text: "/${job.period}",
                                          style: appStyle(16, Color(kDarkGrey.value), FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // Tabs
                        TabBar(
                          controller: _tabController,
                          labelColor: Color(kDark.value),
                          unselectedLabelColor: Color(kDarkGrey.value),
                          indicatorColor: Color(kLightBlue.value),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: appStyle(14, Color(kDark.value), FontWeight.w600),
                          tabs: const [
                            Tab(text: "Description"),
                            Tab(text: "Requirements"),
                            Tab(text: "Company"),
                            Tab(text: "Reviews"),
                          ],
                        ),
                        // Tab Content
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Description Tab
                              SingleChildScrollView(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.description,
                                      style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
                                    ),
                                    const HeightSpacer(size: 10),
                                    Text(
                                      "Accepted Disabilities:",
                                      style: appStyle(16, Color(kDark.value), FontWeight.bold),
                                    ),
                                    const HeightSpacer(size: 5),
                                    ...job.acceptedDisabilities.map((d) => Padding(
                                      padding: EdgeInsets.only(bottom: 8.w),
                                      child: Text(
                                        d.type,
                                        style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              // Requirements Tab
                              ListView.builder(
                                padding: EdgeInsets.all(16.w),
                                itemCount: job.requirements.length,
                                itemBuilder: (context, index) {
                                  String requirement = job.requirements[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.w),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "• ",
                                          style: appStyle(14, Color(kDark.value), FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            requirement,
                                            style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Company Tab
                              _buildCompanyTab(job),
                              // Reviews Tab
                              _buildReviewsTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Apply/Add Review Button
                    Positioned(
                      left: 20.w,
                      right: 20.w,
                      bottom: 20.w,
                      child: _selectedTabIndex == 3
                          ? CustomOutlineBtn(
                        text: "Add Review",
                        hieght: hieght * 0.06,
                        onTap: () => _showAddReviewModal(context),
                        color: Color(kLight.value),
                        color2: Color(kLightBlue.value),
                      )
                          : !isAgent
                          ? CustomOutlineBtn(
                        text: !loginNotifier.loggedIn ? "Please Login" : "Apply",
                        hieght: hieght * 0.06,
                        onTap: () async {
                          if (!loginNotifier.loggedIn) return;

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? userUid = prefs.getString('uid');
                          if (userUid == null || userUid.isEmpty) {
                            print('Error: User UID is empty or not found');
                            return;
                          }

                          Map<String, dynamic> jobDetails = {
                            'job_id': job.id,
                            'image_url': job.imageUrl,
                            'salary': "${job.salary} per ${job.period}",
                            'title': job.title,
                            'company': job.company
                          };

                          List<String> users = [job.agentId, userUid];
                          String chatRoomId = '${job.id}.$userUid';
                          String messageType = 'text';

                          print('Constructed chatRoomId: $chatRoomId');

                          bool doesChatExist = await services.chatRoomExist(chatRoomId);

                          if (!doesChatExist) {
                            createChat(jobDetails, users, chatRoomId, messageType);
                            AppliedPost model = AppliedPost(job: job.id);
                            var newModel = appliedPostToJson(model);
                            AppliedHelper.applyJob(newModel);
                          }

                          zoomNotifier.currentIndex = 1;
                          Get.to(() => const Mainscreen());
                        },
                        color: Color(kLight.value),
                        color2: Color(kLightBlue.value),
                      )
                          : CustomOutlineBtn(
                        text: 'Edit Job',
                        onTap: () {
                          jobUpdate = job;
                          Get.off(() => const UpdateJobs());
                        },
                        hieght: hieght * 0.06,
                        color: Color(kLight.value),
                        color2: Color(kLightBlue.value),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    });
  }
}