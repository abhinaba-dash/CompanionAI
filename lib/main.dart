import 'package:chatgpt/provider/chat_provider.dart';
import 'package:chatgpt/provider/models_provider.dart';
import 'package:chatgpt/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Chat GPT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Gcolors.neutralColor900,
            appBarTheme: AppBarTheme(color: Color.fromRGBO(28, 27, 31, 1))),
        home: const ChatScreen(),
      ),
    );
  }
}
