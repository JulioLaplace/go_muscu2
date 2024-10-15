import 'package:flutter/cupertino.dart';

class HomePageProvider extends ChangeNotifier {
  int navBarIndex = 0;

  void setNavBarIndex(int index) {
    navBarIndex = index;
    notifyListeners();
  }
}
