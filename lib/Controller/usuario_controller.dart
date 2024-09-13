import 'package:flutter/cupertino.dart';

import '../Models/usuario_model.dart';
import '../repositories/usuario_repository.dart';

class UsuarioController extends ChangeNotifier {
  final repository = UsuarioRepository();
  late UsuarioModel usuarioLogado;

  Future<bool> logar(String login, String senha) async {
    try {
      usuarioLogado = await repository.fetchLogin(login, senha);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
