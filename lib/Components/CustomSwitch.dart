import 'package:lanchonete/Controller/Theme.Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return Switch(
      onChanged: (bool value) {
        themeController.changeTheme(value);
      },
      value: themeController.isDark,
    );
  }
}
