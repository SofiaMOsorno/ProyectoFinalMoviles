import 'package:cloud_firestore/cloud_firestore.dart';

class QueueMemberModel {
  final String id;
  final String userId;
  final String username;
  final int position;
  final DateTime joinedAt;
  final DateTime? timeoutStartedAt;

  QueueMemberModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.position,
    required this.joinedAt,
    this.timeoutStartedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'position': position,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'timeoutStartedAt': timeoutStartedAt != null ? Timestamp.fromDate(timeoutStartedAt!) : null,
    };
  }

  factory QueueMemberModel.fromMap(String id, Map<String, dynamic> map) {
    return QueueMemberModel(
      id: id,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      position: map['position'] ?? 0,
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      timeoutStartedAt: (map['timeoutStartedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory QueueMemberModel.fromDocument(DocumentSnapshot doc) {
    return QueueMemberModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  QueueMemberModel copyWith({
    String? id,
    String? userId,
    String? username,
    int? position,
    DateTime? joinedAt,
    DateTime? timeoutStartedAt,
  }) {
    return QueueMemberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      position: position ?? this.position,
      joinedAt: joinedAt ?? this.joinedAt,
      timeoutStartedAt: timeoutStartedAt ?? this.timeoutStartedAt,
    );
  }
}
