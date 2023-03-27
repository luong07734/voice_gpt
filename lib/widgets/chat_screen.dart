// chat_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_gpt/data/apis/chat_apis.dart';
import 'package:voice_gpt/data/providers/is_auto_tts.dart';
import 'package:voice_gpt/data/providers/speech_language.dart';
import 'package:voice_gpt/models/chat_message.dart';
import 'package:voice_gpt/widgets/components/message_bubble.dart';
import 'package:voice_gpt/widgets/components/message_compose.dart';
import 'package:voice_gpt/widgets/setting_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.chatApi,
    super.key,
  });

  final ChatApi chatApi;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messages = <ChatMessage>[
    // ChatMessage('Hello, how can I help?', false),
  ];

  var _awaitingResponse = false;

  Future<void> _onSubmitted(String message) async {
    setState(() {
      _messages.add(ChatMessage(message, true));
      _awaitingResponse = true;
    });
    try {
      final response;
      if (_messages.length < 6) {
        response = await widget.chatApi.completeChat(_messages);
      } else {
        response = await widget.chatApi
            .completeChat(_messages.sublist(_messages.length - 5));
      }
      setState(() {
        _messages.add(ChatMessage(response, false));
        _awaitingResponse = false;
      });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      setState(() {
        _awaitingResponse = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SpeechLanguageProfile speechLanguageProfile =
        Provider.of<SpeechLanguageProfile>(context);
    AutoTTSProfile autoTTSProfile = Provider.of<AutoTTSProfile>(context);
        
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
              null;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._messages.map((msg) {
                  
                  return MessageBubble(
                    content: msg.content,
                    isUserMessage: msg.isUserMessage,
                    languageCode: speechLanguageProfile.speechLanguageCode,
                    isAutoRead: _messages.indexOf(msg) == _messages.length-1 ? autoTTSProfile.autoTTS:false,
                  );
                }),
              ],
            ),
          ),
          MessageComposer(
            onSubmitted: _onSubmitted,
            awaitingResponse: _awaitingResponse,
          ),
        ],
      ),
    );
  }
}
