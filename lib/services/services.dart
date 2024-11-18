import 'package:chatgpt/widgets/drop_down.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      backgroundColor: scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(label: 'Chosen model: ', fontSize: 16),
              ),
              Flexible(
                child: ModelsDropDown(),
                flex: 2,
              )
            ],
          ),
        );
      },
    );
  }
}
