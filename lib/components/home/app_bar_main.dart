import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/settings_button.dart';

// ignore: must_be_immutable
class AppBarMain extends StatefulWidget implements PreferredSizeWidget {
  int currentIndex;
  AppBarMain({super.key, this.currentIndex = 0});

  @override
  // ignore: library_private_types_in_public_api
  _AppBarMainState createState() => _AppBarMainState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarMainState extends State<AppBarMain> {
  // Our dynamic AppBar content
  List<Widget> appBarActions = [
    const SettingsButton(),
  ];

  _setAppBarTitle() {
    switch (widget.currentIndex) {
      case 0:
        return 'Trainings';
      case 1:
        return 'Workouts';
      case 2:
        return 'Your exercises';
      case 3:
        return 'Profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      centerTitle: false,
      title: Text(
        _setAppBarTitle(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: appBarActions,
    );
  }
}
