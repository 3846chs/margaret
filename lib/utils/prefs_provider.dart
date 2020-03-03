import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider {
  SharedPreferences _prefs;

  Future<void> initialize() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  bool isNotificationEnabled(String peerName) {
    return !getNotifications().contains(peerName);
  }

  List<String> getNotifications() {
    return _prefs.getStringList("notifications") ?? <String>[];
  }

  Future<void> setNotification(String peerName, bool enabled) {
    final notifications = getNotifications();
    if (enabled) {
      notifications.remove(peerName);
      return _prefs.setStringList("notifications", notifications);
    } else if (!notifications.contains(peerName)) {
      notifications.add(peerName);
      return _prefs.setStringList("notifications", notifications);
    }

    return null;
  }

  String getAnswer() {
    return _prefs.getString("answer");
  }

  Future<void> setAnswer(String answer) {
    return _prefs.setString("answer", answer);
  }

  String getMessage(String chatKey) {
    return _prefs.getString(chatKey);
  }

  Future<void> setMessage(String chatKey, String message) {
    return _prefs.setString(chatKey, message);
  }
}

final PrefsProvider prefsProvider = PrefsProvider();
