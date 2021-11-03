import 'package:lanchonete/Interfaces/Local_Storage.Interface.dart';
import 'package:lanchonete/Services/Local_storage.Service.dart';
import 'package:flutter/material.dart';

class ConfigController {
  static final ConfigController instance = ConfigController._();
  final ILocalStorage storage = LocalStorageService();
  final baseURL = ValueNotifier<String?>('');

  Future<String> getUrlBase() async {
    if (baseURL.value != '') {
      return 'http://${baseURL.value}:9000';
    }
    await getConfig();
    return 'http://${baseURL.value}:9000';
  }

  ConfigController._() {
    getConfig();
  }

  getConfig() async {
    var url = await storage.get('urlBase');
    if (url != null) {
      changeUrlBase(url.toString());
    }
  }

  changeUrlBase(String? value) {
    baseURL.value = value;
    storage.put('urlBase', value);
  }
}
