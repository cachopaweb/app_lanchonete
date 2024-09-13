import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/categoria_model.dart';
import 'package:dio/dio.dart';

Future<List<Categoria>> fetchCategorias() async {
  final url = await ConfigController.instance.getUrlBase();
  BaseOptions options = new BaseOptions(
    baseUrl: url,
    connectTimeout: Duration(milliseconds: 50000),
    receiveTimeout: Duration(milliseconds: 50000),
  );

  Dio dio = new Dio(options);
  final response = await dio.get<List>('/Categorias');
  final resultado =
      response.data!.map((json) => Categoria.fromJson(json)).toList();
  return resultado;
}

Future<String?> fetchFotoCategoria(int? codigo) async {
  final url = await ConfigController.instance.getUrlBase();
  BaseOptions options = new BaseOptions(
    baseUrl: url,
    connectTimeout: Duration(milliseconds: 50000),
    receiveTimeout: Duration(milliseconds: 50000),
  );

  Dio dio = new Dio(options);
  final response = await dio.get('/Categorias/$codigo/foto');
  final resultado = Map<String, dynamic>.from(response.data);
  return resultado['base64'];
}
