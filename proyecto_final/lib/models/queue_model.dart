import 'package:cloud_firestore/cloud_firestore.dart';

class QueueModel {
  final String id;
  final String title;
  final String description;
  final int maxPeople;
  final int timerSeconds;
  final bool enableNotifications;
  final String creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int currentCount;
  final String? fileUrl;

  QueueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.maxPeople,
    required this.timerSeconds,
    required this.enableNotifications,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.currentCount = 0,
    this.fileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'maxPeople': maxPeople,
      'timerSeconds': timerSeconds,
      'enableNotifications': enableNotifications,
      'creatorId': creatorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'currentCount': currentCount,
      'fileUrl': fileUrl,
    };
  }

  factory QueueModel.fromMap(String id, Map<String, dynamic> map) {
    return QueueModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      maxPeople: map['maxPeople'] ?? 20,
      timerSeconds: map['timerSeconds'] ?? 60,
      enableNotifications: map['enableNotifications'] ?? false,
      creatorId: map['creatorId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
      currentCount: map['currentCount'] ?? 0,
      fileUrl: map['fileUrl'],
    );
  }

  factory QueueModel.fromDocument(DocumentSnapshot doc) {
    return QueueModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  QueueModel copyWith({
    String? id,
    String? title,
    String? description,
    int? maxPeople,
    int? timerSeconds,
    bool? enableNotifications,
    String? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    int? currentCount,
    String? fileUrl,
  }) {
    return QueueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      maxPeople: maxPeople ?? this.maxPeople,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      currentCount: currentCount ?? this.currentCount,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
