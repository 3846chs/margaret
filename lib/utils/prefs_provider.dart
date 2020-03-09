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

  String getAnswer(String userKey) {
    return _prefs.getString("$userKey:answer");
  }

  Future<void> setAnswer(String userKey, String answer) {
    return _prefs.setString("$userKey:answer", answer);
  }

  String getMessage(String myKey, String peerKey) {
    return _prefs.getString("$myKey:$peerKey");
  }

  Future<void> setMessage(String myKey, String peerKey, String message) {
    return _prefs.setString("$myKey:$peerKey", message);
  }

  bool getTodayQuestionAlarm() {
    return _prefs.getBool("todayQuestion") ?? true;
  }

  Future<void> setTodayQuestionAlarm(bool value) {
    return _prefs.setBool("todayQuestion", value);
  }
}

final PrefsProvider prefsProvider = PrefsProvider();
