import 'dart:math';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/model_models.dart';
import 'package:chatgpt/provider/chat_provider.dart';
import 'package:chatgpt/provider/models_provider.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:chatgpt/services/asset_manager.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

import 'dart:developer' as devtools;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController scrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  //List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        leading: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(AssetsManager.openaiLogo)),
        title: const Text('Chat GPT'),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: Column(children: [
        Flexible(
          child: ListView.builder(
            controller: scrollController,
            itemCount: chatProvider.getChatList.length,
            //chatList.length,
            itemBuilder: (context, index) {
              // return Text('data');
              return ChatWidget(
                msg: chatProvider.getChatList[index].msg,
                //chatList[index].msg,
                chatIndex: chatProvider.getChatList[index].chatIndex,
                //chatList[index].chatIndex,
              );
            },
          ),
        ),
        if (_isTyping) ...[
          const SpinKitThreeBounce(
            color: Colors.white,
            size: 18,
          ),
        ],
        SizedBox(
          height: 15,
        ),
        Material(
          color: cardColor,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    style: TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) async {
                      await sendMessageScreen(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider);
                    },
                    decoration: InputDecoration.collapsed(
                        hintText: 'How can I help you',
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await sendMessageScreen(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider);
                      //                   try {
                      //   _isTyping = true;
                      //   devtools.log('Request has been sent');
                      //   await ApiServices.sendMessage(
                      //       msgs: textEditingController.text,
                      //       modelId: modelsProvider.getCurrentModel);
                      //   setState(() {});
                      // } catch (e) {
                      //   print('error $e');
                      // } finally {
                      //   _isTyping = false;
                      // }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        )
      ]),
    );
  }

  void scrollEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2), curve: Curves.easeOut);
  }

  Future<void> sendMessageScreen(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    String userInput = textEditingController.text;
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "Please avoid sending multiple messages", fontSize: 16),
        backgroundColor: Colors.redAccent,
      ));
      ;
    }
    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "Please type a message", fontSize: 16),
        backgroundColor: Colors.redAccent,
      ));
      ;
    }
    try {
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: userInput);
        //chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      devtools.log('Request has been sent');
      await chatProvider.sendMessageAnswer(
          msg: userInput,
          modelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiServices.sendMessage(
      //     msgs: textEditingController.text,
      //     modelId: modelsProvider.getCurrentModel));
      setState(() {});
    } catch (e) {
      print('error $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "Caught an error ", fontSize: 16),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      _isTyping = false;
      scrollEnd();
    }
  }
}
