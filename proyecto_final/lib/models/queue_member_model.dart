import 'package:cloud_firestore/cloud_firestore.dart';

class QueueMemberModel {
  final String id;
  final String userId;
  final String username;
  final int position;
  final DateTime joinedAt;

  QueueMemberModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.position,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'position': position,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }

  factory QueueMemberModel.fromMap(String id, Map<String, dynamic> map) {
    return QueueMemberModel(
      id: id,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      position: map['position'] ?? 0,
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
  }) {
    return QueueMemberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      position: position ?? this.position,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
