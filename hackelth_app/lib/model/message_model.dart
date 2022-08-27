class MessageModel {
  String text;
  MessageModel({
    required this.text,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(text: json['message']);
  }
  
}
