import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/services/fcm_service.dart';

class QueueNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FCMService _fcmService = FCMService();

  // Listen to queue position changes and send local notifications
  void listenToQueuePositionChanges(String queueId, String userId) {
    _firestore
        .collection('queues')
        .doc(queueId)
        .collection('members')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isEmpty) return;

      final memberData = snapshot.docs.first.data();
      final position = memberData['position'] as int;

      // Send notification when user reaches position 0
      if (position == 0) {
        await _sendPositionZeroNotification(queueId);
      }
      // Send notification when user reaches position 1
      else if (position == 1) {
        await _sendPositionOneNotification(queueId);
      }
    });
  }

  // Send notification when user is at position 0
  Future<void> _sendPositionZeroNotification(String queueId) async {
    try {
      final queueDoc = await _firestore.collection('queues').doc(queueId).get();
      if (!queueDoc.exists) return;

      final queueTitle = queueDoc.data()!['title'] as String;

      await _fcmService.sendLocalNotification(
        title: "It's Your Turn! 🎉",
        body: "You're now first in line for $queueTitle. Get ready!",
        data: {
          'type': 'your_turn',
          'queueId': queueId,
          'queueTitle': queueTitle,
        },
      );
    } catch (e) {
      print('Error sending position 0 notification: $e');
    }
  }

  // Send notification when user is at position 1
  Future<void> _sendPositionOneNotification(String queueId) async {
    try {
      final queueDoc = await _firestore.collection('queues').doc(queueId).get();
      if (!queueDoc.exists) return;

      final queueTitle = queueDoc.data()!['title'] as String;

      await _fcmService.sendLocalNotification(
        title: "You're Next! 👀",
        body: "Get ready! You're next in line for $queueTitle",
        data: {
          'type': 'youre_next',
          'queueId': queueId,
          'queueTitle': queueTitle,
        },
      );
    } catch (e) {
      print('Error sending position 1 notification: $e');
    }
  }

  // Check position and send notification immediately (for testing)
  Future<void> checkAndNotifyPosition(String queueId, String userId) async {
    try {
      final memberSnapshot = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .where('userId', isEqualTo: userId)
          .get();

      if (memberSnapshot.docs.isEmpty) return;

      final memberData = memberSnapshot.docs.first.data();
      final position = memberData['position'] as int;

      if (position == 0) {
        await _sendPositionZeroNotification(queueId);
      } else if (position == 1) {
        await _sendPositionOneNotification(queueId);
      }
    } catch (e) {
      print('Error checking position: $e');
    }
  }
}