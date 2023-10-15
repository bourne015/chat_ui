import 'package:flutter/widgets.dart';

import 'chat.dart';
import 'message.dart';
import '../utils/constants.dart';

//all chat pages
class Pages with ChangeNotifier {
  final Map<int, Chat> _pages = {};
  final List<int> _pagesID = [];
  int _currentPageID = -1;
  int _maxPageID = 0;
  String _defaultModelVersion = ModelVersion.gptv35;
  bool _isDrawerOpen = true;
  bool _displayInitPage = true;

  bool get displayInitPage => _displayInitPage;
  set displayInitPage(bool val) {
    _displayInitPage = val;
    notifyListeners();
  }

  set currentPageID(int cid) {
    _currentPageID = cid;
    notifyListeners();
  }

  int get currentPageID => _currentPageID;
  Chat? get currentPage {
    if (currentPageID >= 0) {
      return _pages[_currentPageID]!;
    } else {
      return null;
    }
  }

  int get pagesLen => _pages.length;

  String get defaultModelVersion => _defaultModelVersion;

  set defaultModelVersion(String? v) {
    _defaultModelVersion = v!;
    notifyListeners();
  }

  bool get isDrawerOpen => _isDrawerOpen;
  set isDrawerOpen(bool v) {
    _isDrawerOpen = v;
    notifyListeners();
  }

  int get assignNewPageID {
    return _maxPageID++;
  }

  void addPage(int pageID, Chat newChat) {
    _pages[pageID] = newChat;
    _pagesID.add(pageID);
    notifyListeners();
  }

  void delPage(int pageID) {
    _pages.remove(pageID);
    _pagesID.remove(pageID);
    notifyListeners();
  }

  Chat getPage(int pageID) => _pages[pageID]!;

  int getNthPageID(int n) {
    if (n >= _pagesID.length) {
      debugPrint("out of range");
      return _pagesID[0];
    }
    return _pagesID[n];
  }

  void setPageTitle(int pageID, String title) {
    _pages[pageID]?.title = title;
    notifyListeners();
  }

  void addMessage(int pageID, Message newMsg) {
    _pages[pageID]?.addMessage(newMsg);
    notifyListeners();
  }

  void appendMessage(int pageID, String newMsg) {
    _pages[pageID]?.appendMessage(newMsg);
    notifyListeners();
  }

  List<Message>? getMessages(int pageID) => _pages[pageID]?.messages;
  List<Widget>? getMessageBox(int pageID) => _pages[pageID]?.messageBox;

  void clearMsg(int pageID) {
    _pages[pageID]?.messages.clear();
    _pages[pageID]?.messageBox.clear();
    notifyListeners();
  }
}
