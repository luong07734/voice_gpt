import 'package:flutter/material.dart';
import 'package:voice_gpt/data/shared_preferences/shared_preferences.dart';

class AutoTTSProfile extends ChangeNotifier {
  final SharedPreference _prefHelper = SharedPreference.instance;
  bool currentAutoTTS = true;
  bool get autoTTS => currentAutoTTS;

  AutoTTSProfile() {
    _loadAutoTTS();
  }

  _loadAutoTTS() async {
    print("_loadAutoTTS called");
    bool? currentAutoTTSfromPref = await _prefHelper.isAutoTTS;
    if (currentAutoTTSfromPref == null) {
      return;
    }

    currentAutoTTS = currentAutoTTSfromPref;
    print(currentAutoTTSfromPref);

    notifyListeners();
  }

  void changeAutoTTS(bool isAutoTTS) {
    currentAutoTTS = isAutoTTS;

    _prefHelper.saveIsAutoTTS(isAutoTTS);
    // FirebaseAnalytics.instance
    //     .logEvent(name: 'change_language', parameters: {'language': language});

    notifyListeners();
  }
}
