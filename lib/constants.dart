import 'package:flutter/material.dart';

class AppColors {
  static const titleBar = Colors.blueGrey;
  static const chatPageTitle = Colors.white;
  static const chatPageTitleToken = Colors.white;
  static const modelSelectorBackground = Color.fromARGB(255, 100, 120, 128);
  static const modelSelected = Color.fromARGB(255, 71, 86, 171);

  static final drawerTabSelected = Colors.grey[300];
  static const drawerDivider = Color.fromARGB(255, 186, 182, 182);

  static final chatPageBackground = Colors.grey[200];
  static final inputBoxBackground = Colors.grey[300];
  static final inputTextField = Colors.blue[50];
  static final userMsgBox = Colors.purple[400];
  static const aiMsgBox = Colors.white;
  static const msgText = Colors.black;
}

enum GPT { v35, v40 }

const GPT defaultModel = GPT.v35;

const double drawerWidth = 265;

const String urlSSE = "https://fantao.life:8001/v1/stream/chat";
const String url1Chat = "https://fantao.life:8001/v1/chat";
