import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/login_provider.dart';
import 'package:jobility/controllers/zoom_provider.dart';

class FirebaseServices {
<<<<<<< HEAD
  CollectionReference typing = FirebaseFirestore.instance.collection('typing');
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference status = FirebaseFirestore.instance.collection('status');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  createChatRoom(Map<String, dynamic> chatData) {
    chats.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void addTypingStatus(String chatRoomId) {
    typing.doc(chatRoomId).collection('typing').doc(userUid).set({});
  }

  void userStatus() {
    status.doc('status').collection(userUid).doc(userUid).set({});
  }

  void removeStatus(ZoomNotifier zoomNotifier, LoginNotifier loginNotifier) {
    if (zoomNotifier.currentIndex != 1 && loginNotifier.loggedIn == true) {
      status.doc('status').collection(userUid).doc(userUid).delete();
    }
    
  }

  void removeTypingStatus(String chatRoomId) {
    typing.doc(chatRoomId).collection('typing').doc(userUid).delete();
  }

  createChat(String chatRoomId, message) {
    chats.doc(chatRoomId).collection('messages').add(message).catchError((e) {
      debugPrint(e.toString());
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
    });
  }

  updateCount(String chatRoomId) {
    chats.doc(chatRoomId).update({'read': true});
  }

  Future<bool> chatRoomExist(String chatRoomId) async {
    DocumentReference chatRoomRef = chats.doc(chatRoomId);

    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    return chatRoomSnapshot.exists;
  }
}
=======
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  late final CollectionReference typing;
  late final CollectionReference chats;
  late final CollectionReference status;
  late final CollectionReference messages;

  // Constructor
  FirebaseServices() {
    typing = _firestore.collection('typing');
    chats = _firestore.collection('chats');
    status = _firestore.collection('status');
    messages = _firestore.collection('messages');
    debugPrint('FirebaseServices initialized');
  }

  // Get chat messages stream
  Stream<QuerySnapshot> getChatMessages(String chatRoomId) {
    debugPrint('Getting chat messages for room: $chatRoomId');
    try {
      return chats
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      debugPrint('Error getting chat messages: $e');
      rethrow;
    }
  }

  // Get chat rooms stream
  Stream<QuerySnapshot> getChatRooms() {
    debugPrint('Getting chat rooms for user: $userUid');
    try {
      return chats
          .where('participants', arrayContains: userUid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      debugPrint('Error getting chat rooms: $e');
      rethrow;
    }
  }

  // Create chat room
  Future<void> createChatRoom(Map<String, dynamic> chatData) async {
    debugPrint('Creating chat room with data: $chatData');
    try {
      await chats.doc(chatData['chatRoomId']).set(chatData);
      debugPrint('Chat room created successfully');
    } catch (e) {
      debugPrint('Error creating chat room: $e');
      throw Exception('Error creating chat room: $e');
    }
  }


  // Add typing status
  Future<void> addTypingStatus(String chatRoomId) async {
    debugPrint('Adding typing status for user: $userUid in room: $chatRoomId');
    try {
      await typing.doc(chatRoomId).collection('typing').doc(userUid).set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('Typing status added successfully');
    } catch (e) {
      debugPrint('Error adding typing status: $e');
      rethrow;
    }
  }

  // Get typing status stream
  Stream<QuerySnapshot> getTypingStatus(String chatRoomId) {
    debugPrint('Getting typing status for room: $chatRoomId');
    try {
      return typing
          .doc(chatRoomId)
          .collection('typing')
          .snapshots();
    } catch (e) {
      debugPrint('Error getting typing status: $e');
      rethrow;
    }
  }

  // Update user status
  Future<void> userStatus() async {
    debugPrint('Updating user status for: $userUid');
    try {
      await status.doc('status').collection(userUid).doc(userUid).set({
        'lastSeen': FieldValue.serverTimestamp(),
        'online': true,
      });
      debugPrint('User status updated successfully');
    } catch (e) {
      debugPrint('Error updating user status: $e');
      rethrow;
    }
  }

  // Get user status stream
  Stream<DocumentSnapshot> getUserStatus(String userId) {
    debugPrint('Getting user status for: $userId');
    try {
      return status
          .doc('status')
          .collection(userId)
          .doc(userId)
          .snapshots();
    } catch (e) {
      debugPrint('Error getting user status: $e');
      rethrow;
    }
  }

  // Remove user status
  Future<void> removeStatus(ZoomNotifier zoomNotifier, LoginNotifier loginNotifier) async {
    debugPrint('Removing status for user: $userUid');
    try {
      if (zoomNotifier.currentIndex != 1 && loginNotifier.loggedIn == true) {
        await status.doc('status').collection(userUid).doc(userUid).update({
          'online': false,
          'lastSeen': FieldValue.serverTimestamp(),
        });
        debugPrint('Status removed successfully');
      }
    } catch (e) {
      debugPrint('Error removing status: $e');
      rethrow;
    }
  }

  // Remove typing status
  Future<void> removeTypingStatus(String chatRoomId) async {
    debugPrint('Removing typing status for user: $userUid in room: $chatRoomId');
    try {
      await typing.doc(chatRoomId).collection('typing').doc(userUid).delete();
      debugPrint('Typing status removed successfully');
    } catch (e) {
      debugPrint('Error removing typing status: $e');
      rethrow;
    }
  }

  // Create chat message
  Future<void> createChat(String chatRoomId, dynamic messageData) async {
    debugPrint('Creating chat message in room: $chatRoomId');
    debugPrint('Message data: $messageData');

    try {
      // Validate chat room exists
      bool exists = await chatRoomExist(chatRoomId);
      if (!exists) {
        throw Exception('Chat room does not exist: $chatRoomId');
      }

      // Convert dynamic message to Map
      final Map<String, dynamic> message = Map<String, dynamic>.from(messageData);

      // Validate message data
      _validateMessageData(message);

      // Add timestamp to message
      final Map<String, dynamic> messageWithTimestamp = {
        ...message,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add message to collection
      DocumentReference messageRef = await chats
          .doc(chatRoomId)
          .collection('messages')
          .add(messageWithTimestamp);

      debugPrint('Message added with ID: ${messageRef.id}');

      // Remove typing status
      await removeTypingStatus(chatRoomId);

      // Update chat room with latest message info
      final Map<String, dynamic> chatUpdate = {
        'messageType': message['messageType'],
        'sender': message['sender'],
        'profile': message['profile'],
        'id': message['id'],
        'timestamp': FieldValue.serverTimestamp(),
        'lastChat': message['message'],
        'lastChatTime': message['time'],
        'read': false
      };

      await chats.doc(chatRoomId).update(chatUpdate);
      debugPrint('Chat room updated with latest message');
    } catch (e) {
      debugPrint('Error creating chat message: $e');
      rethrow;
    }
  }

  // Get chat room stream
  Stream<DocumentSnapshot> getChatRoom(String chatRoomId) {
    debugPrint('Getting chat room: $chatRoomId');
    try {
      return chats.doc(chatRoomId).snapshots();
    } catch (e) {
      debugPrint('Error getting chat room: $e');
      rethrow;
    }
  }

  // Update read status
  Future<void> updateCount(String chatRoomId) async {
    debugPrint('Updating read status for room: $chatRoomId');
    try {
      await chats.doc(chatRoomId).update({
        'read': true,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('Read status updated successfully');
    } catch (e) {
      debugPrint('Error updating read status: $e');
      rethrow;
    }
  }

  // Check if chat room exists
  Future<bool> chatRoomExist(String chatRoomId) async {
    debugPrint('Checking if chat room exists: $chatRoomId');
    try {
      DocumentSnapshot chatRoomSnapshot = await chats.doc(chatRoomId).get();
      bool exists = chatRoomSnapshot.exists;
      debugPrint('Chat room exists: $exists');
      return exists;
    } catch (e) {
      debugPrint('Error checking chat room existence: $e');
      rethrow;
    }
  }

  // Validate message data
  void _validateMessageData(Map<String, dynamic> message) {
    final requiredFields = ['message', 'sender', 'messageType', 'profile', 'id', 'time'];

    for (String field in requiredFields) {
      if (!message.containsKey(field)) {
        throw Exception('Missing required field: $field');
      }
    }

    if (message['message'].toString().isEmpty) {
      throw Exception('Message content cannot be empty');
    }

    debugPrint('Message data validated successfully');
  }
}
>>>>>>> 80bcbd8 (hehe)
