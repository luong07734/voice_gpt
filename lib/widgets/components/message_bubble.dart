import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    super.key,
  });

  final String content;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isUserMessage
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
            alignment: isUserMessage ? WrapAlignment.end : WrapAlignment.start,
            children: [
              Padding(
                padding: isUserMessage
                    ? const EdgeInsets.only(left: 70)
                    : const EdgeInsets.only(right: 70),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUserMessage
                        ? themeData.colorScheme.primary.withOpacity(0.4)
                        : themeData.colorScheme.secondary.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: isUserMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        isUserMessage
                            ? const SizedBox(
                                height: 0,
                              )
                            : const Text(
                                'ChatGPT',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                        isUserMessage
                            ? const SizedBox(height: 0)
                            : const SizedBox(height: 8),
                        Text(
                          content,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        isUserMessage
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
