import 'package:flutter/cupertino.dart';

class MesaController {
  final atualizar = ValueNotifier<bool>(false);
  static final MesaController instance = MesaController._();

  MesaController._();

  changeAtualizar() {
    atualizar.value = !atualizar.value;
  }
}
