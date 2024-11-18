import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chatgpt/constants/api_constant.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/model_models.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools;

class ApiServices {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse('$base_url/models'),
          headers: {'Authorization': 'Bearer $base_api_key'});

      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (jsonResponse['error'] != null) {
        print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      List modelTemp = [];
      for (var value in jsonResponse['data']) {
        modelTemp.add(value);
        print("modelTemp ${value['id']}");
      }

      return ModelsModel.modelsSnapshotList(modelTemp);
    } catch (error) {
      print('error $error');
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String msgs, required String modelId}) async {
    devtools.log('model id $modelId');
    try {
      var responseChat = await http.post(Uri.parse('$base_url/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $base_api_key'
          },
          body: jsonEncode({
            "model": modelId,
            "prompt": msgs,
            "max_tokens": 100,
            "temperature": 0
          }));

      Map jsonChatResponse = jsonDecode(responseChat.body);
      if (jsonChatResponse['error'] != null) {
        throw HttpException(jsonChatResponse["error"]["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonChatResponse["choices"].length > 0) {
        // print(
        //     'jsonChatResponse[choices]text ${jsonChatResponse["choices"][0]["text"]}');
        chatList = List.generate(
            jsonChatResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonChatResponse["choices"][index]["text"], chatIndex: 1));
      }
      return chatList;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }
}
