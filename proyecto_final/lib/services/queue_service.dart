import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/models/queue_model.dart';
import 'package:proyecto_final/models/queue_member_model.dart';

class QueueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createQueue({
    required String title,
    required String description,
    required int maxPeople,
    required int timerSeconds,
    required bool enableNotifications,
    required String creatorId,
    String? fileUrl,
  }) async {
    try {
      final now = DateTime.now();

      final queueData = {
        'title': title,
        'description': description,
        'maxPeople': maxPeople,
        'timerSeconds': timerSeconds,
        'enableNotifications': enableNotifications,
        'creatorId': creatorId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'currentCount': 0,
        'fileUrl': fileUrl,
      };

      DocumentReference docRef = await _firestore.collection('queues').add(queueData);

      return docRef.id;
    } catch (e) {
      throw 'Error creating queue: $e';
    }
  }

  Future<void> updateQueue({
    required String queueId,
    String? title,
    String? description,
    int? maxPeople,
    int? timerSeconds,
    bool? enableNotifications,
    bool? isActive,
    String? fileUrl,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (maxPeople != null) updates['maxPeople'] = maxPeople;
      if (timerSeconds != null) updates['timerSeconds'] = timerSeconds;
      if (enableNotifications != null) updates['enableNotifications'] = enableNotifications;
      if (isActive != null) updates['isActive'] = isActive;
      if (fileUrl != null) updates['fileUrl'] = fileUrl;

      await _firestore.collection('queues').doc(queueId).update(updates);
    } catch (e) {
      throw 'Error updating queue: $e';
    }
  }

  Future<void> deleteQueue(String queueId) async {
    try {
      final membersSnapshot = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .get();

      for (var doc in membersSnapshot.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('queues').doc(queueId).delete();
    } catch (e) {
      throw 'Error deleting queue: $e';
    }
  }

  Future<QueueModel?> getQueue(String queueId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('queues').doc(queueId).get();

      if (!doc.exists) {
        return null;
      }

      return QueueModel.fromDocument(doc);
    } catch (e) {
      throw 'Error fetching queue: $e';
    }
  }

  Stream<List<QueueModel>> getUserQueues(String userId) {
    return _firestore
        .collection('queues')
        .where('creatorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => QueueModel.fromDocument(doc)).toList();
    });
  }

  Stream<List<QueueModel>> getActiveQueues() {
    return _firestore
        .collection('queues')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => QueueModel.fromDocument(doc)).toList();
    });
  }

  Future<String> addMemberToQueue({
    required String queueId,
    required String userId,
    required String username,
  }) async {
    try {
      final queueDoc = await _firestore.collection('queues').doc(queueId).get();

      if (!queueDoc.exists) {
        throw 'Queue not found';
      }

      final queueData = queueDoc.data()!;
      final currentCount = queueData['currentCount'] ?? 0;
      final maxPeople = queueData['maxPeople'] ?? 20;

      if (currentCount >= maxPeople) {
        throw 'Queue is full';
      }

      final existingMember = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .where('userId', isEqualTo: userId)
          .get();

      if (existingMember.docs.isNotEmpty) {
        throw 'User already in queue';
      }

      final memberData = {
        'userId': userId,
        'username': username,
        'position': currentCount,
        'joinedAt': FieldValue.serverTimestamp(),
      };

      DocumentReference memberRef = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .add(memberData);

      await _firestore.collection('queues').doc(queueId).update({
        'currentCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return memberRef.id;
    } catch (e) {
      throw 'Error joining queue: $e';
    }
  }

  Future<void> removeMemberFromQueue({
    required String queueId,
    required String memberId,
  }) async {
    try {
      await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .doc(memberId)
          .delete();

      await _firestore.collection('queues').doc(queueId).update({
        'currentCount': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _reorderQueuePositions(queueId);
    } catch (e) {
      throw 'Error removing member from queue: $e';
    }
  }

  Future<void> updateMemberPosition({
    required String queueId,
    required String memberId,
    required int newPosition,
  }) async {
    try {
      await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .doc(memberId)
          .update({
        'position': newPosition,
      });
    } catch (e) {
      throw 'Error updating member position: $e';
    }
  }

  Future<void> reorderMembers({
    required String queueId,
    required List<QueueMemberModel> members,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (int i = 0; i < members.length; i++) {
        DocumentReference memberRef = _firestore
            .collection('queues')
            .doc(queueId)
            .collection('members')
            .doc(members[i].id);

        batch.update(memberRef, {'position': i});
      }

      await batch.commit();

      await _firestore.collection('queues').doc(queueId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error reordering members: $e';
    }
  }

  Stream<List<QueueMemberModel>> getQueueMembers(String queueId) {
    return _firestore
        .collection('queues')
        .doc(queueId)
        .collection('members')
        .orderBy('position')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => QueueMemberModel.fromDocument(doc)).toList();
    });
  }

  Future<void> _reorderQueuePositions(String queueId) async {
    try {
      final membersSnapshot = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .orderBy('position')
          .get();

      WriteBatch batch = _firestore.batch();

      for (int i = 0; i < membersSnapshot.docs.length; i++) {
        batch.update(membersSnapshot.docs[i].reference, {'position': i});
      }

      await batch.commit();
    } catch (e) {
      throw 'Error reordering positions: $e';
    }
  }

  Future<int> getQueueMemberCount(String queueId) async {
    try {
      final snapshot = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw 'Error getting member count: $e';
    }
  }

  Future<bool> isUserInQueue(String queueId, String userId) async {
    try {
      final snapshot = await _firestore
          .collection('queues')
          .doc(queueId)
          .collection('members')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw 'Error checking user in queue: $e';
    }
  }
}
