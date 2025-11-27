import 'package:shared_preferences/shared_preferences.dart';

class GuestSessionService {
  static const String _guestUserIdKey = 'guest_user_id';
  static const String _guestQueueIdKey = 'guest_queue_id';
  static const String _guestUserNameKey = 'guest_user_name';

  Future<void> saveGuestSession({
    required String guestUserId,
    required String queueId,
    required String userName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_guestUserIdKey, guestUserId);
    await prefs.setString(_guestQueueIdKey, queueId);
    await prefs.setString(_guestUserNameKey, userName);
  }

  Future<Map<String, String>?> getGuestSession() async {
    final prefs = await SharedPreferences.getInstance();

    final guestUserId = prefs.getString(_guestUserIdKey);
    final queueId = prefs.getString(_guestQueueIdKey);
    final userName = prefs.getString(_guestUserNameKey);

    if (guestUserId != null && queueId != null && userName != null) {
      return {
        'guestUserId': guestUserId,
        'queueId': queueId,
        'userName': userName,
      };
    }

    return null;
  }

  Future<void> clearGuestSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestUserIdKey);
    await prefs.remove(_guestQueueIdKey);
    await prefs.remove(_guestUserNameKey);
  }

  Future<bool> hasActiveSession() async {
    final session = await getGuestSession();
    return session != null;
  }
}
