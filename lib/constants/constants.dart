import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

Color scaffoldBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);

final chatMessages = [
  {'msg': 'Hello, this is Chat GPT ', 'chatIndex': 0},
  {'msg': 'Holaaaaaaa ', 'chatIndex': 1},
  {'msg': 'Priyatosh ', 'chatIndex': 0},
  {'msg': 'aare aare', 'chatIndex': 1},
  {'msg': 'Heheheehehe ', 'chatIndex': 0},
];

final List<String> models = [
  'Model1',
  'Model2',
  'Model3',
  'Model4',
  'Model5',
  'Model6',
];

List<DropdownMenuItem<String>>? get getModelsItem {
  List<DropdownMenuItem<String>>? getModelsItem =
      List<DropdownMenuItem<String>>.generate(
    models.length,
    (index) => DropdownMenuItem(
      value: models[index],
      child: TextWidget(label: models[index], fontSize: 15),
    ),
  );
  return getModelsItem;
}
