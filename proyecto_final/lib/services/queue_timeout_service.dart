import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/services/queue_service.dart';
import 'package:proyecto_final/models/queue_member_model.dart';

class QueueTimeoutService {
  static final QueueTimeoutService _instance = QueueTimeoutService._internal();
  factory QueueTimeoutService() => _instance;
  QueueTimeoutService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final QueueService _queueService = QueueService();
  final Map<String, StreamSubscription> _queueListeners = {};
  Timer? _checkTimer;

  void startMonitoring(String queueId) {
    // Evitar múltiples listeners para la misma fila
    if (_queueListeners.containsKey(queueId)) {
      return;
    }

    // Escuchar cambios en los miembros de la fila
    final subscription = _queueService.getQueueMembers(queueId).listen((members) {
      if (members.isNotEmpty) {
        _checkTimeout(queueId, members.first);
      }
    });

    _queueListeners[queueId] = subscription;
  }

  void stopMonitoring(String queueId) {
    _queueListeners[queueId]?.cancel();
    _queueListeners.remove(queueId);
  }

  void stopAllMonitoring() {
    for (var subscription in _queueListeners.values) {
      subscription.cancel();
    }
    _queueListeners.clear();
    _checkTimer?.cancel();
  }

  Future<void> _checkTimeout(String queueId, QueueMemberModel member) async {
    try {
      // Si no tiene timeoutStartedAt, no hay nada que verificar
      if (member.timeoutStartedAt == null) {
        return;
      }

      // Obtener la configuración de la fila
      final queue = await _queueService.getQueue(queueId);
      if (queue == null || !queue.isActive) {
        return;
      }

      final now = DateTime.now();
      final timeoutStartedAt = member.timeoutStartedAt!;
      final elapsedSeconds = now.difference(timeoutStartedAt).inSeconds;

      // Si el tiempo ha expirado, remover al miembro
      if (elapsedSeconds >= queue.timerSeconds) {
        await _queueService.removeMemberFromQueue(
          queueId: queueId,
          memberId: member.id,
        );
      }
    } catch (e) {
      print('Error checking timeout: $e');
    }
  }

  // Método para iniciar un timer global que verifica periódicamente
  void startGlobalMonitoring() {
    _checkTimer?.cancel();

    // Verificar cada 5 segundos todas las filas activas
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final queuesSnapshot = await _firestore
            .collection('queues')
            .where('isActive', isEqualTo: true)
            .get();

        for (var queueDoc in queuesSnapshot.docs) {
          final queueId = queueDoc.id;
          final queueData = queueDoc.data();
          final timerSeconds = queueData['timerSeconds'] ?? 60;

          // Obtener el primer miembro
          final membersSnapshot = await _firestore
              .collection('queues')
              .doc(queueId)
              .collection('members')
              .orderBy('position')
              .limit(1)
              .get();

          if (membersSnapshot.docs.isEmpty) {
            continue;
          }

          final memberDoc = membersSnapshot.docs.first;
          final memberData = memberDoc.data();
          final timeoutStartedAt = (memberData['timeoutStartedAt'] as Timestamp?)?.toDate();

          if (timeoutStartedAt != null) {
            final now = DateTime.now();
            final elapsedSeconds = now.difference(timeoutStartedAt).inSeconds;

            // Si el tiempo ha expirado, remover al miembro
            if (elapsedSeconds >= timerSeconds) {
              await _queueService.removeMemberFromQueue(
                queueId: queueId,
                memberId: memberDoc.id,
              );
            }
          }
        }
      } catch (e) {
        print('Error in global monitoring: $e');
      }
    });
  }

  void stopGlobalMonitoring() {
    _checkTimer?.cancel();
  }
}
