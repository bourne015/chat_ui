import 'package:flutter/material.dart';

const String appTitle = 'Chat Demo';

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

class MessageRole {
  static const String system = "system";
  static const String user = "user";
  static const String assistant = "assistant";
}

class ModelVersion {
  static const String gptv35 = "GPT-3.5";
  static const String gptv40 = "GPT-4.0";
}

const double drawerWidth = 260;

const String urlSSE = "http://127.0.0.1:8001/v1/stream/chat";
const String url1Chat = "http://127.0.0.1:8001/v1/chat";

const String aboutText = "A Demo for ChatGPT-3.5, the token is limited, "
    "Please refresh the page if reached max tokens"
    "or don't need question context";
