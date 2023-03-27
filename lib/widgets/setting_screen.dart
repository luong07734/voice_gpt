import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_gpt/data/providers/is_auto_tts.dart';
import 'package:voice_gpt/data/providers/speech_language.dart';
import 'package:voice_gpt/widgets/components/custom_switch.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isToggleOn = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final SpeechLanguageProfile speechLanguageProfile =
        Provider.of<SpeechLanguageProfile>(context);
    final AutoTTSProfile autoTTSProfile = Provider.of<AutoTTSProfile>(context);

    if (speechLanguageProfile.speechLanguageCode ==
        SpeechLanguageProfile.enSpeechLanguageCode) {
      _selectedLanguage = 'English';
    } else {
      _selectedLanguage = "Vietnamese";
    }
    _isToggleOn = autoTTSProfile.autoTTS;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.play_circle),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Auto TTS Replies',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  CustomSwitch(
                    initialValue: autoTTSProfile.autoTTS,
                    onChanged: (value) {
                      // Do something when the switch is tapped

                      setState(() {
                        autoTTSProfile.changeAutoTTS(value);
                        _isToggleOn = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Speech Language',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'English') {
                          speechLanguageProfile.changeLanguage(
                              SpeechLanguageProfile.enSpeechLanguageCode);
                          _selectedLanguage = 'English';
                        } else if (newValue == "Vietnamese") {
                          speechLanguageProfile.changeLanguage(
                              SpeechLanguageProfile.viSpeechLanguageCode);
                          _selectedLanguage = 'Vietnamese';
                        }
                      });
                    },
                    items: <String>['English', 'Vietnamese']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
