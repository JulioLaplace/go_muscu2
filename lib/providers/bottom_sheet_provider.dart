import 'dart:collection';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomSheetProvider with ChangeNotifier {
  double bottomSheetHeight = 100;
  Widget? currentBottomSheetItem;
  Queue<Widget> previousBottomSheetItem = Queue<Widget>();
  bool isBottomSheetOpen = false;
  bool isCurrentTrainingInBottomSheet = false;
  // navbar controller
  final bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  void setBottomSheetHeight(double height, [bool init = false]) {
    bottomSheetHeight = height;
    if (!init) {
      notifyListeners();
    }
  }

  void setBottomSheetWidget(Widget widget) {
    currentBottomSheetItem = widget;
    notifyListeners();
  }

  void addPreviousBottomSheetWidget(
    Widget widget,
  ) {
    previousBottomSheetItem.addLast(widget);

    notifyListeners();
  }

  void removePreviousBottomSheetWidget() {
    previousBottomSheetItem.removeLast();
    notifyListeners();
  }

  void openBottomSheet() {
    isBottomSheetOpen = true;
    bottomBarController.openSheet();
    setCurrentTrainingInBottomSheet(false);
    notifyListeners();
  }

  void closeBottomSheet() {
    isBottomSheetOpen = false;
    bottomBarController.closeSheet();
    notifyListeners();
  }

  void removeBottomSheetWidget() {
    currentBottomSheetItem = null;
    notifyListeners();
  }

  void setCurrentTrainingInBottomSheet(bool value) {
    isCurrentTrainingInBottomSheet = value;
    notifyListeners();
  }
}
