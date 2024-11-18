import 'package:chatgpt/models/model_models.dart';
import 'package:chatgpt/provider/models_provider.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../services/services.dart';

class ModelsDropDown extends StatefulWidget {
  const ModelsDropDown({super.key});

  @override
  State<ModelsDropDown> createState() => _ModelsDropDownState();
}

class _ModelsDropDownState extends State<ModelsDropDown> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.currentModel;
    return FutureBuilder<List<ModelsModel>?>(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString(), fontSize: 16),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                      snapshot.data!.length,
                      (index) => DropdownMenuItem(
                        child: TextWidget(
                            label: snapshot.data![index].id, fontSize: 16),
                        value: snapshot.data![index].id,
                      ),
                    ),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      modelsProvider.setCurrentModel(value.toString());
                    },
                  ),
                );
        });
  }
}


// DropdownButton(
//         dropdownColor: scaffoldBackgroundColor,
//         items: getModelsItem,
//         value: currentModel,
//         onChanged: (value) {
//           setState(() {
//             currentModel = value.toString();
//           });
//         });