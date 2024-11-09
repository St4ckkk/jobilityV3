import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {
  CollectionReference typing = FirebaseFirestore.instance.collection('typing');
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference status = FirebaseFirestore.instance.collection('status');
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  String userUid = '';

  FirebaseServices() {
    _initializeUserUid();
  }

  Future<void> _initializeUserUid() async {
    await _getUserUid();
  }

  Future<void> _getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('uid') ?? '';
    print('FirebaseServices: Retrieved userUid: $userUid');
  }

  Future<void> createChatRoom(Map<String, dynamic> chatData) async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in createChatRoom: userUid is empty or null');
      return;
    }
    print('Creating chat room with data: $chatData');
    chats.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      debugPrint('Error in createChatRoom: ${e.toString()}');
    });
  }

  Future<void> addTypingStatus(String chatRoomId) async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in addTypingStatus: userUid is empty or null');
      return;
    }
    print('Adding typing status for chatRoomId: $chatRoomId');
    typing.doc(chatRoomId).collection('typing').doc(userUid).set({}).catchError((e) {
      debugPrint('Error in addTypingStatus: ${e.toString()}');
    });
  }

  Future<void> userStatus() async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in userStatus: userUid is empty or null');
      return;
    }
    print('Updating user status for userUid: $userUid');
    status.doc(userUid).set({
      'lastActive': FieldValue.serverTimestamp(),
      'isOnline': true
    }).catchError((e) {
      debugPrint('Error in userStatus: ${e.toString()}');
    });
  }

  Future<void> removeStatus(ZoomNotifier zoomNotifier, LoginNotifier loginNotifier) async {
    await _getUserUid();
    if (zoomNotifier.currentIndex != 1 && loginNotifier.loggedIn == true) {
      if (userUid.isNotEmpty) {
        try {
          print('Removing status for user: $userUid');
          status.doc(userUid).delete().catchError((error) {
            print('Error in removeStatus: ${error.toString()}');
          });
        } catch (e) {
          print('Exception in removeStatus: ${e.toString()}');
        }
      } else {
        print('Error in removeStatus: userUid is empty or null');
      }
    }
  }

  Future<void> removeTypingStatus(String chatRoomId) async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in removeTypingStatus: userUid is empty or null');
      return;
    }
    print('Removing typing status for chatRoomId: $chatRoomId');
    typing.doc(chatRoomId).collection('typing').doc(userUid).delete().catchError((e) {
      debugPrint('Error in removeTypingStatus: ${e.toString()}');
    });
  }

  Future<void> createChat(String chatRoomId, message) async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in createChat: userUid is empty or null');
      return;
    }
    print('Creating chat in chatRoomId: $chatRoomId with message: $message');
    chats.doc(chatRoomId).collection('messages').add(message).catchError((e) {
      debugPrint('Error in createChat: ${e.toString()}');
    });
    removeTypingStatus(chatRoomId);
    chats.doc(chatRoomId).update({
      'messageType': message['messageType'],
      'sender': message['sender'],
      'profile': message['profile'],
      'id': message['id'],
      'timestamp': Timestamp.now(),
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'read': false
    }).catchError((e) {
      debugPrint('Error in createChat update: ${e.toString()}');
    });
  }

  Future<void> updateCount(String chatRoomId) async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in updateCount: userUid is empty or null');
      return;
    }
    print('Updating read count for chatRoomId: $chatRoomId');
    chats.doc(chatRoomId).update({'read': true}).catchError((e) {
      debugPrint('Error in updateCount: ${e.toString()}');
    });
  }

  Future<bool> chatRoomExist(String chatRoomId) async {
    await _getUserUid();
    if (userUid.isEmpty) {
      print('Error in chatRoomExist: userUid is empty or null');
      return false;
    }
    print('Checking if chat room exists for chatRoomId: $chatRoomId');
    DocumentReference chatRoomRef = chats.doc(chatRoomId);
    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get().catchError((e) {
      debugPrint('Error in chatRoomExist: ${e.toString()}');
    });
    return chatRoomSnapshot.exists;
  }
}