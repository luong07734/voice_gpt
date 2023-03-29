class ChatMessage {
  ChatMessage({required this.content,required this.isUserMessage});

  String content;
  bool isUserMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      isUserMessage: json['isUserMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['content'] = this.content;
    data['isUserMessage'] = this.isUserMessage;
    return data;
  }
}
