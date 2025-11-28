import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FCMTokenService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene el token FCM del dispositivo actual
  Future<String?> getToken() async {
    try {
      // Solicitar permisos de notificación
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Obtener el token
        String? token = await _messaging.getToken();
        return token;
      }

      return null;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Guarda o actualiza el token FCM en Firestore para un usuario específico
  Future<void> saveTokenToFirestore(String userId) async {
    try {
      String? token = await getToken();

      if (token != null) {
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        });
        print('FCM token saved successfully for user: $userId');
      }
    } catch (e) {
      // Si el documento no existe, intentar usar set con merge
      try {
        String? token = await getToken();
        if (token != null) {
          await _firestore.collection('users').doc(userId).set({
            'fcmToken': token,
            'tokenUpdatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('FCM token saved with merge for user: $userId');
        }
      } catch (e2) {
        print('Error saving FCM token: $e2');
      }
    }
  }

  /// Configura el listener para cuando el token se actualice
  void setupTokenRefreshListener(String userId) {
    _messaging.onTokenRefresh.listen((newToken) {
      _firestore.collection('users').doc(userId).update({
        'fcmToken': newToken,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      }).catchError((error) {
        print('Error updating token on refresh: $error');
      });
    });
  }

  /// Elimina el token FCM de Firestore (útil al cerrar sesión)
  Future<void> deleteTokenFromFirestore(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
        'tokenUpdatedAt': FieldValue.delete(),
      });
      print('FCM token deleted for user: $userId');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
