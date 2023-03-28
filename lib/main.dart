import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_gpt/data/apis/chat_apis.dart';
import 'package:voice_gpt/data/providers/is_auto_tts.dart';
import 'package:voice_gpt/data/providers/speech_language.dart';
import 'package:voice_gpt/widgets/chat_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<SpeechLanguageProfile>(
        create: (_) => SpeechLanguageProfile()),
    ChangeNotifierProvider<AutoTTSProfile>(create: (_) => AutoTTSProfile()),
  ], child: MyApp(chatApi: ChatApi())));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.chatApi, super.key});
  final ChatApi chatApi;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.lime,
        ),
      ),
      home: ChatPage(chatApi: chatApi),
    );
  }
}

// TODO: xu ly play/stop
// TODO: xu ly history cua vanban
