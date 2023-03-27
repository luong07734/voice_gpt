import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_gpt/data/shared_preferences/constants/shared_preferences_keys.dart';

class SharedPreference {
  // shared pref instance
  static SharedPreference? _instance;

  static SharedPreference get instance {
    _instance ??= SharedPreference._();
    return _instance!;
  }

  // constructor
  SharedPreference._();

  Future<String?> get currentSpeechLanguage async {
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference
        .getString(SharedPreferenceKeys.currentSpeechLanguage);
  }

  Future<bool> saveCurrentLanguage(String currentSpeechLanguage) async {
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference.setString(
        SharedPreferenceKeys.currentSpeechLanguage, currentSpeechLanguage);
  }

  Future<bool?> get isAutoTTS async {
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference.getBool(SharedPreferenceKeys.isAutoTTS);
  }

  Future<bool> saveIsAutoTTS(bool isAutoTTS) async {
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference.setBool(SharedPreferenceKeys.isAutoTTS, isAutoTTS);
  }
}
