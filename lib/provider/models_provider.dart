import 'package:chatgpt/models/model_models.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = 'text-davinci-003';

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiServices.getModels();
    return modelsList;
  }
}
