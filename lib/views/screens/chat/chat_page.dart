import 'package:cloud_firestore/cloud_firestore.dart'; import 'package:flutter/material.dart'; import 'package:flutter_screenutil/flutter_screenutil.dart'; import 'package:jobility/constants/app_constants.dart'; import 'package:jobility/controllers/agents_provider.dart'; import 'package:jobility/services/firebase_services.dart'; import 'package:jobility/utils/date.dart'; import 'package:jobility/views/common/BackBtn.dart'; import 'package:jobility/views/common/app_style.dart'; import 'package:jobility/views/common/reusable_text.dart'; import 'package:jobility/views/common/width_spacer.dart'; import 'package:jobility/views/screens/auth/profile_page.dart'; import 'package:jobility/views/screens/chat/widgets/chat_left_item.dart'; import 'package:jobility/views/screens/chat/widgets/chat_right_item.dart'; import 'package:jobility/views/screens/chat/widgets/messagin_field.dart'; import 'package:provider/provider.dart'; import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget { const ChatPage({super.key});

@override State<ChatPage> createState() => _ChatPageState(); }

class _ChatPageState extends State<ChatPage> { FirebaseServices services = FirebaseServices(); TextEditingController messageController = TextEditingController(); final itemController = ItemScrollController(); final FocusNode messageFocusNode = FocusNode(); var uuid = Uuid();

String imageUrl = "https://d326fntlu7tb1e.cloudfront.net/uploads/4c004766-c0ad-42ed-bef1-6a7616b24c11-vinci_11.jpg";

sendMessage() { var chat = Provider.of<AgentNotifier>(context, listen: false).chat;

Map<String, dynamic> message = {
  'message': messageController.text,
  'messageType': 'text',
  'profile': profile,
  'sender': userUid,
  'id': uuid.v4(),
  'time': Timestamp.now()
};

services.createChat(chat['chatRoomId'], message);
messageController.clear();
FocusScope.of(context).removeListener(() {});
}

@override Widget build(BuildContext context) { String chatRoomId = Provider.of<AgentNotifier>(context, listen: false).chat['chatRoomId'];

final Stream<QuerySnapshot> typingStatus = FirebaseFirestore.instance
    .collection('typing')
    .doc(chatRoomId)
    .collection('typing')
    .snapshots();

final Stream<QuerySnapshot> chats = FirebaseFirestore.instance
    .collection('chats')
    .doc(chatRoomId)
    .collection('messages')
    .orderBy('time')
    .snapshots();

final Stream<QuerySnapshot> userStatus = FirebaseFirestore.instance
    .collection('status')
    .doc('status')
    .collection(userUid)
    .snapshots();

return Scaffold(
  backgroundColor: Color(kLight.value),
  appBar: AppBar(
    backgroundColor: Color(kLight.value),
    elevation: 0,
    leading: Padding(padding: EdgeInsets.all(12.w), child: const BackBtn()),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: typingStatus,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error : $snapshot.error");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Text('');
                    }
                    List<String> documentIds =
                    snapshot.data!.docs.map((doc) => doc.id).toList();

                    return ReusableText(
                        text: documentIds.isNotEmpty &&
                            !documentIds.contains(userUid)
                            ? 'typing...'
                            : "",
                        style:
                        appStyle(9, Colors.black54, FontWeight.normal));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: userStatus,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error : $snapshot.error");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Text('');
                    }
                    List<String> documentIds =
                    snapshot.data!.docs.map((doc) => doc.id).toList();

                    return Consumer<AgentNotifier>(
                      builder: (context, agentNotifier, child) {
                        List users = agentNotifier.chat['users'];
                        String secondUser =
                        users.firstWhere((user) => user != userUid);

                        return ReusableText(
                            text: "online",
                            style: appStyle(
                                9, Colors.green, FontWeight.normal));
                      },
                    );
                  },
                ),
              ],
            ),
            Stack(
              children: [
                CircularAvata(image: imageUrl, w: 30, h: 30),
                Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.green.shade600,
                      radius: 4,
                    ))
              ],
            )
          ],
        ),
      )
    ],
  ),
  body: SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0.h,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.only(left: 5.w, right: 20.w, top: 10.w),
              width: width,
              height: 120.h,
              decoration: BoxDecoration(
                color: Color(kNewBlue.value),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w),
                  topRight: Radius.circular(20.w),
                ),
              ),
              child: Column(
                children: [
                  Consumer<AgentNotifier>(
                    builder: (context, agentNotifier, child) {
                      var jobDetails = agentNotifier.chat['job'];

                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(
                                        text: 'Company',
                                        style: appStyle(11, Color(kLight.value),
                                            FontWeight.w500)),
                                    ReusableText(
                                        text: 'Job Title',
                                        style: appStyle(11, Color(kLight.value),
                                            FontWeight.w500)),
                                    ReusableText(
                                        text: 'Salary',
                                        style: appStyle(11, Color(kLight.value),
                                            FontWeight.w500)),
                                  ],
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Container(
                                    height: 60.w,
                                    width: 1.w,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(
                                        text: jobDetails['company'],
                                        style: appStyle(11, Color(kLight.value),
                                            FontWeight.w500)),
                                    ReusableText(
                                        text: jobDetails['title'],
                                        style: appStyle(11, Color(kLight.value),
                                            FontWeight.w500)),
                                    ReusableText(
                                        text: jobDetails['salary'],
                                        style: appStyle(11, Color(kLight.value),
                                            FontWeight.w500)),
                                  ],
                                )
                              ],
                            ),
                            const WidthSpacer(width: 20),
                            CircularAvata(
                                image: jobDetails['image_url'], w: 50, h: 50)
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: 85.w,
              left: 0,
              right: 0,
              child: Container(
                width: width,
                height: hieght * 0.75,
                decoration: BoxDecoration(
                    color: Color(kGreen.value),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.w),
                      topRight: Radius.circular(20.w),
                    )),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.w),
                      child: StreamBuilder(
                        stream: chats,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error $snapshot.error');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          } else if (snapshot.data!.docs.isEmpty == true) {
                            return const SizedBox.shrink();
                          }
                          int msgCount = snapshot.data!.docs.length;
                          return Column(
                            children: [
                              Container(
                                height: hieght * .66,
                                padding: EdgeInsets.all(8.w),
                                child: ScrollablePositionedList.builder(
                                    itemCount: msgCount,
                                    initialScrollIndex: msgCount,

                                    itemScrollController: itemController,
                                    itemBuilder: (context, index) {
                                      var message = snapshot.data!.docs[index];

                                      Timestamp lastChatTime = message['time'];
                                      DateTime chatTime = lastChatTime.toDate();

                                      return Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Column(
                                          children: [
                                            Text(duTimeLineFormat(chatTime),
                                                style: appStyle(10, Colors.grey,
                                                    FontWeight.normal)),
                                            message['sender'] == userUid
                                                ? chatRightItem(
                                                message['messageType'],
                                                message['message'],
                                                message['profile'])
                                                : chatLeftItem(
                                                message['messageType'],
                                                message['message'],
                                                message['profile'])
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 0.h,
                        child: MessagingField(
                            sendText: () {
                              sendMessage();
                            },
                            messageController: messageController,
                            messageFocusNode: messageFocusNode))
                  ],
                ),
              ))
        ],
      )),
);
} }