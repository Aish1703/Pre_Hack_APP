class MessageModel {
  String text;
  String query;

  MessageModel({required this.text, this.query = "0"});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(text: json['message'], query: json['query']);
  }
}

class SkinDiseaseModel {
  String disease;
  String accuracy;

  SkinDiseaseModel({required this.disease, required this.accuracy});

  factory SkinDiseaseModel.fromJson(Map<String, dynamic> json) {
    return SkinDiseaseModel(
        disease: json['disease'], accuracy: json['accuracy']);
  }
}
