import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    super.key,
  });

  final String content;
  final bool isUserMessage;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

enum TtsState { playing, stopped, paused, continued }

class _MessageBubbleState extends State<MessageBubble> {
  // TextToSpeech tts = TextToSpeech();
  late FlutterTts flutterTts;

  String? language;
  String? engine;
  double volume = 10;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;
  @override
  void initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  // Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  // Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak(String content) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage("vi-VN");
    _printLanguages();
    print(content);
    if (content != null) {
      if (content.isNotEmpty) {
        await flutterTts.speak(content);
      }
    }
  }

  Future _printLanguages() async {
    List<dynamic> languages = await flutterTts.getLanguages;
    print(languages);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isUserMessage
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/images/chatgpt-logo.svg',
                  width: 30,
                  height: 30,
                ),
              ),
        Expanded(
          child: Wrap(
            alignment:
                widget.isUserMessage ? WrapAlignment.end : WrapAlignment.start,
            children: [
              Padding(
                padding: widget.isUserMessage
                    ? const EdgeInsets.only(left: 70)
                    : const EdgeInsets.only(right: 70),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isUserMessage
                        ? themeData.colorScheme.primary.withOpacity(0.4)
                        : themeData.colorScheme.secondary.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: widget.isUserMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        widget.isUserMessage
                            ? const SizedBox(
                                height: 0,
                              )
                            : const Text(
                                'ChatGPT',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                        widget.isUserMessage
                            ? const SizedBox(height: 0)
                            : const SizedBox(height: 8),
                        Text(
                          widget.content,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        widget.isUserMessage
            ? Container()
            : IconButton(
                onPressed: () => _speak(widget.content),
                icon: Icon(Icons.volume_up),
              ),

        // : IconButton(
        //     onPressed: () => _stop(),
        //     icon: Icon(Icons.volume_down),
        //   ),
        widget.isUserMessage
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  'assets/images/user-logo.svg',
                  width: 40,
                  height: 40,
                ),
              )
            : Container(),
      ],
    );
  }
}
