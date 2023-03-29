import 'package:dart_openai/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voice_gpt/data/apis/constants/api_constants.dart';
import 'package:voice_gpt/models/chat_message.dart';

class ChatApi {
  ChatApi() {
    OpenAI.apiKey = dotenv.env['API_KEY']!;
    // OpenAI.organization = openAiOrg;
  }

  Future<String> completeChat(List<ChatMessage> messages) async {
    final chatCompletion = await OpenAI.instance.chat.create(
      model: MODEL,
      messages: messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage
                    ? OpenAIChatMessageRole.user
                    : OpenAIChatMessageRole.assistant,
                content: e.content,
              ))
          .toList(),
    );
    return chatCompletion.choices.first.message.content;
  }
}
