
import 'package:apk_manager/core/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalController {

LocalController._privateConstructor();
  static final LocalController _instance = LocalController._privateConstructor();
  factory LocalController() => _instance;

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setAppVersion(String identifier, int appVersion) {
    _prefs.setInt('app_v_$identifier', appVersion);
  }

  int getAppVersion(String identifier) {
    return _prefs.getInt('app_v_$identifier') ?? firstVersion;
  }

}