import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/agents_provider.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/services/firebase_services.dart';
import 'package:jobility/utils/date.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/drawer/drawer_widget.dart';
import 'package:jobility/views/common/height_spacer.dart';
import 'package:jobility/views/common/pages_loader.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/screens/agent/agent_details.dart';
import 'package:jobility/views/screens/auth/non_user.dart';
import 'package:jobility/views/screens/chat/chat_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/request/agents/agents.dart';
import '../../common/loader.dart';
import '../../common/width_spacer.dart';
import '../auth/profile_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 3, vsync: this);
  String imageUrl =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/b8bac89b-b85d-4ead-bb9e-57c96e03a08b-vinci_02.jpg";

  FirebaseServices services = FirebaseServices();
  String userUid = '';
  bool isAgent = false;
  Stream<QuerySnapshot>? _chat; // Make _chat nullable

  @override
  void initState() {
    super.initState();
    _getUserUid();
  }

  Future<void> _getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('uid') ?? '';
    isAgent = prefs.getBool('isAgent') ?? false;
    if (userUid.isNotEmpty) {
      // Initialize the stream only when userUid is available
      _chat = FirebaseFirestore.instance
          .collection('chats')
          .where('users', arrayContains: userUid)
          .snapshots();
    }
    print('Retrieved userUid: $userUid');
    print('Is Agent: $isAgent');
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    if (loginNotifier.loggedIn == true) {
      services.userStatus();
    }

    return FutureBuilder(
      future: _getUserUid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          print('Building ChatList for userUid: $userUid');
          print('User is ${isAgent ? "an Agent" : "a Regular User"}');

          return Scaffold(
            backgroundColor: const Color(0xFF171717),
            appBar: AppBar(
              backgroundColor: const Color(0xFF171717),
              elevation: 0,
              leading: Padding(
                padding: EdgeInsets.all(12.w),
                child: DrawerWidget(color: Color(kLight.value)),
              ),
              title: loginNotifier.loggedIn == false
                  ? const SizedBox.shrink()
                  : TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: const Color(0x00BABABA),
                  borderRadius: BorderRadius.all(Radius.circular(25.w)),
                ),
                labelColor: Color(kLight.value),
                unselectedLabelColor: Colors.grey.withOpacity(.5),
                padding: EdgeInsets.all(3.w),
                labelStyle: appStyle(12, Color(kLight.value), FontWeight.w500),
                tabs: const [
                  Tab(text: "MESSAGE"),
                  Tab(text: "ONLINE"),
                  Tab(text: "GROUPS"),
                ],
              ),
            ),
            body: loginNotifier.loggedIn == false
                ? const NonUser()
                : TabBarView(controller: tabController, children: [
              Stack(
                children: [
                  Positioned(
                      top: 5,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 15.w, left: 25.w, right: 0.w),
                        height: 220.h,
                        decoration: BoxDecoration(
                          color: Color(kNewBlue.value),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.w),
                            topRight: Radius.circular(20.w),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                    text: "Agents and Companies",
                                    style: appStyle(12, Color(kLight.value), FontWeight.normal)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      AntDesign.ellipsis1,
                                      color: Color(kLight.value),
                                    ))
                              ],
                            ),
                            Consumer<AgentNotifier>(
                              builder: (context, agentNotifier, child) {
                                var agents = agentNotifier.getAgents();
                                return FutureBuilder<List<Agents>>(
                                    future: agents,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return SizedBox(
                                          height: 90.h,
                                          child: ListView.builder(
                                              itemCount: 7,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {},
                                                  child: buildAgentAvatar(
                                                    "Agent $index",
                                                    imageUrl,
                                                  ),
                                                );
                                              }),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return SizedBox(
                                          height: 90.h,
                                          child: ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                var agent = snapshot.data![index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    agentNotifier.agent = agent;
                                                    Get.to(() => const AgentDetails());
                                                  },
                                                  child: buildAgentAvatar(
                                                    agent.name ?? 'Unknown Agent',
                                                    agent.profile ?? '',
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                    });
                              },
                            )
                          ],
                        ),
                      )),
                  Positioned(
                      top: 150.h,
                      right: 0,
                      left: 0,
                      child: Container(
                          width: width,
                          height: hieght,
                          decoration: BoxDecoration(
                            color: Color(kGreen.value),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              topRight: Radius.circular(20.w),
                            ),
                          ),
                          child: _chat != null
                              ? StreamBuilder<QuerySnapshot>(
                            stream: _chat,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return const PageLoader();
                              } else if (snapshot.data!.docs.isEmpty) {
                                return const NoSearchResults(text: 'No chats available');
                              }

                              final chatList = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: chatList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 10.w, top: 10.w),
                                itemBuilder: (context, index) {
                                  final chat = chatList[index].data() as Map<String, dynamic>;
                                  Timestamp lastChatTime = chat['lastChatTime'];
                                  DateTime lastChatDateTime = lastChatTime.toDate();

                                  print('Chat data: $chat');
                                  print('Receiver ID: ${chat['receiver']}');
                                  print('Logged-in User ID: $userUid');
                                  print('Is Receiver the Logged-in User: ${chat['receiver'] == userUid}');

                                  String displayName;
                                  String profileImage;

                                  if (chat['sender'] == userUid) {
                                    displayName = chat['agentName'] ?? 'Unknown Receiver';
                                    profileImage = chat['receiver'] == userUid ? imageUrl : chat['receiverProfile'] ?? '';
                                  } else {
                                    displayName = chat['senderName'] ?? 'Unknown Sender';
                                    profileImage = chat['sender'] == userUid ? imageUrl : chat['senderProfile'] ?? '';
                                  }

                                  return Consumer<AgentNotifier>(
                                    builder: (context, agentNotifier, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (chat['sender'] != userUid) {
                                            services.updateCount(chat['chatRoomId']);
                                          }
                                          agentNotifier.chat = chat;
                                          Get.to(() => const ChatPage());
                                        },
                                        child: buildChatRow(
                                          displayName,
                                          chat['lastChat'] ?? '',
                                          profileImage,
                                          chat['read'] == true ? 0 : 1,
                                          lastChatDateTime,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          )
                              : const Center(child: Text('Loading...'))))
                ],
              ),
              Container(
                height: hieght,
                width: width,
                color: Colors.green,
              ),
              Container(
                height: hieght,
                width: width,
                color: Colors.blueAccent,
              ),
            ]),
          );
        }
      },
    );
  }
}

Padding buildAgentAvatar(String name, String filename) {
  return Padding(
    padding: EdgeInsets.only(right: 20.w),
    child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(99.w)),
                border: Border.all(width: 2, color: Color(kLight.value))),
            child: CircularAvata(image: filename, w: 50, h: 50)),
        const HeightSpacer(size: 5),
        ReusableText(
            text: name,
            style: appStyle(11, Color(kLight.value), FontWeight.normal))
      ],
    ),
  );
}

Column buildChatRow(
    String displayName, String message, String filename, int msgCount, DateTime time) {
  return Column(
    children: [
      FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircularAvata(image: filename, w: 50, h: 50),
                const WidthSpacer(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: displayName,
                        style: appStyle(12, Colors.grey, FontWeight.w400)),
                    const HeightSpacer(size: 5),
                    SizedBox(
                      width: width * 0.63,
                      child: ReusableText(
                          text: message,
                          style: appStyle(12, Colors.grey, FontWeight.w400)),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w, left: 15.w, top: 5.w),
              child: Column(
                children: [
                  ReusableText(
                      text: duTimeLineFormat(time),
                      style: appStyle(10, Colors.black, FontWeight.normal)),
                  const HeightSpacer(size: 15),
                  if (msgCount > 0)
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(kNewBlue.value),
                      child: ReusableText(
                          text: msgCount.toString(),
                          style: appStyle(
                              8, Color(kLight.value), FontWeight.normal)),
                    )
                ],
              ),
            )
          ],
        ),
      ),
      const Divider(
        indent: 70,
        height: 20,
      )
    ],
  );
}