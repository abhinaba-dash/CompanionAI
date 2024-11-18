import 'package:chatgpt/models/chat_model.dart';
import 'package:flutter/widgets.dart';

import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAnswer(
      {required String msg, required String modelId}) async {
    chatList.addAll(await ApiServices.sendMessage(msgs: msg, modelId: modelId));
    notifyListeners();
  }
}
