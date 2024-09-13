import 'package:dio/dio.dart';

import '../Controller/Config.Controller.dart';
import '../Models/usuario_model.dart';

class UsuarioRepository {
  Future<List<UsuarioModel>> fetchUsuario() async {
    final url = await ConfigController.instance.getUrlBase();

    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    Dio dio = new Dio(options);
    try {
      final response = await dio.get('/usuarios');
      final list = response.data as List;
      return list.map((e) => UsuarioModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UsuarioModel> fetchLogin(String login, String senha) async {
    final url = await ConfigController.instance.getUrlBase();

    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    Dio dio = new Dio(options);
    try {
      final response = await dio.post('/login', data: {
        'login': login,
        'senha': senha,
      });
      if (response.statusCode == 200) {
        return UsuarioModel.fromMap(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Usuario não autorizado');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
