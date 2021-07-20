import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:dio/dio.dart';

class ProdutosService {
  BaseOptions options;
  Dio dio;

  Future<List<Produtos>> fetchProdutos(String filtro) async {
    String url = '';
    final baseurl = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: baseurl,
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );

    dio = new Dio(options);
    if (filtro != '') {
      url = '/Produtos?categoria=$filtro';
    } else {
      url = '/Produtos';
    }
    final response = await dio.get<List>(url);
    final resultado =
        response.data.map((json) => Produtos.fromJson(json)).toList();
    return resultado;
  }

  Future<Produtos> fetchProduto(int codigo) async {
    Produtos resultado = Produtos();
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );

    dio = new Dio(options);
    try {
      final response = await dio.get('/Produtos/$codigo');
      resultado = Produtos.fromJson(response.data);
    } catch (e) {
      print(e.toString());
    }
    return resultado;
  }

  Future<String> fetchFotoProduto(int codigo) async {
    String url = '';
    url = '/Produtos/$codigo/foto';
    final baseurl = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: baseurl,
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );

    dio = new Dio(options);
    final response = await dio.get(url);
    final resultado = Map<String, dynamic>.from(response.data);
    return resultado['base64'];
  }
}
