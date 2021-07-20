import 'package:lanchonete/Interfaces/Local_Storage.Interface.dart';
import 'package:lanchonete/Services/Local_storage.Service.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  final ILocalStorage storage = LocalStorageService();
  bool _themeSwitch = false;

  bool get isDark => _themeSwitch;

  ThemeController() {
    storage.get('isDark').then((value) {
      if (value != null) changeTheme(value);
    });
  }

  changeTheme(bool value) {
    _themeSwitch = value;
    storage.put('isDark', value);
    notifyListeners();
  }
}
