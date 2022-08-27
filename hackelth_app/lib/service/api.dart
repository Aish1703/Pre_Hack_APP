import 'dart:convert';
import 'package:hackelth_app/model/message_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _apiService = ApiService._internal();

  factory ApiService() {
    return _apiService;
  }

  ApiService._internal();

  Future<Map<String, dynamic>> getData(String endpoint) async {
    Uri uri = getUri(endpoint);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return jsonDecode(response.body);
  }

  Uri getUri(String endpoint) {
    return Uri.parse(endpoint);
  }
}

class SolutionService {
  ApiService service = ApiService();

  Future<MessageModel> getMessages(String text) async {
    String endpoint = "https://astra07.herokuapp.com/get-solution?query=$text";
    var response = await service.getData(endpoint);
    return MessageModel.fromJson(response);
  }

  Future<SkinDiseaseModel> getSkinDisease(String url) async {
    String endpoint =
        "https://astra07.herokuapp.com/get-skin-disease?query=$url";
    var response = await service.getData(endpoint);
    return SkinDiseaseModel.fromJson(response);
  }
}
