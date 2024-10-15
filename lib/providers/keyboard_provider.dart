import 'dart:developer';

import 'package:flutter/cupertino.dart';

class KeyboardProvider extends ChangeNotifier {
  bool isKeyboardVisible = false;
  bool displayExtraBox = false;
  bool isKeyboardGoingOut = false;
  double keyboardHeight = 0;

  void setKeyboardVisibility(bool isVisible) {
    isKeyboardVisible = isVisible;
    notifyListeners();
  }

  void setKeyboardHeight(double height) {
    if (height < keyboardHeight) {
      isKeyboardGoingOut = true;
    }
    if (height == 0) {
      isKeyboardGoingOut = false;
    }
    keyboardHeight = height;
    log('isKeyboardGoingOut: $isKeyboardGoingOut');
    notifyListeners();
  }

  void setDisplayExtraBox(bool display) {
    displayExtraBox = display;
    notifyListeners();
  }
}
