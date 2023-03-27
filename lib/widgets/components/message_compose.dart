import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MessageComposer extends StatefulWidget {
  MessageComposer({
    required this.onSubmitted,
    required this.awaitingResponse,
    super.key,
  });

  final void Function(String) onSubmitted;
  final bool awaitingResponse;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _messageController = TextEditingController();
  late stt.SpeechToText _speech;
  bool isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _stopListening() async {
    _speech.stop();
    setState(() {
      isListening = false;
    });
  }

  void _listen() async {
    print("listen");
    if (!isListening) {
      bool available = await _speech.initialize(
          onError: (error) => () {
                print('Error: $error');
                setState(() {
                  isListening = false;
                });
              },
          onStatus: (status) => print('Status: $status'));

      if (available) {
        setState(() {
          // set the mic icon to indicate that the user is speaking
          isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              // update the text in the text field
              // isListening = false;
              print(result.recognizedWords);
              _messageController.text = result.recognizedWords;
              if (result.finalResult) {
                if (_messageController.text.isNotEmpty) {
                  widget.onSubmitted(_messageController.text);
                  _messageController.clear();
                }
                isListening = false;
              }
            });
          },
          // listenFor: Duration(seconds: 10),
          // pauseFor: Duration(seconds: 5),
          // partialResults: true,
        );
      } else {
        setState(() {
          print("stop");
          isListening = false;
          _speech.stop();
        });
      }
    }
    print(isListening);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.05),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: !widget.awaitingResponse
                  ? TextField(
                      controller: _messageController,
                      onSubmitted: widget.onSubmitted,
                      decoration: const InputDecoration(
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Fetching response...'),
                        ),
                      ],
                    ),
            ),
            IconButton(
              icon: isListening
                  ? Icon(
                      Icons.mic,
                      color: Colors.red,
                    )
                  : Icon(Icons.mic),
              onPressed: isListening ? _stopListening : _listen,
            ),
            IconButton(
              onPressed: !widget.awaitingResponse
                  ? () {
                      if (_messageController.text.isNotEmpty) {
                        widget.onSubmitted(_messageController.text);
                        _messageController.clear();
                      }
                    }
                  : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
