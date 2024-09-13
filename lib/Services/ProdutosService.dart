import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/grade_produto_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:dio/dio.dart';

class ProdutosService {
  BaseOptions? options;
  late Dio dio;

  Future<List<Produtos>> fetchProdutos(String filtro) async {
    String url = '';
    try {
      final baseurl = await ConfigController.instance.getUrlBase();
      BaseOptions options = new BaseOptions(
        baseUrl: baseurl,
        connectTimeout: Duration(milliseconds: 50000),
        receiveTimeout: Duration(milliseconds: 50000),
      );

      dio = new Dio(options);
      if (filtro != '') {
        url = '/Produtos$filtro';
      } else {
        url = '/Produtos';
      }
      final response = await dio.get<List>(url);
      final resultado =
          response.data!.map((json) => Produtos.fromJson(json)).toList();
      return resultado;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Produtos> fetchProduto(int codigo) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    try {
      final response = await dio.get('/Produtos/$codigo');
      return Produtos.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> fetchFotoProduto(int? codigo) async {
    String url = '';
    try {
      url = '/Produtos/$codigo/foto';
      final baseurl = await ConfigController.instance.getUrlBase();
      BaseOptions options = new BaseOptions(
        baseUrl: baseurl,
        connectTimeout: Duration(milliseconds: 50000),
        receiveTimeout: Duration(milliseconds: 50000),
      );

      dio = new Dio(options);
      final response = await dio.get(url);
      final resultado = Map<String, dynamic>.from(response.data);
      return resultado['base64'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<GradeProduto>> fetchGradesProduto(int codigo) async {
    String url = '';
    try {
      url = '/Produtos/Grades/$codigo';
      final baseurl = await ConfigController.instance.getUrlBase();
      BaseOptions options = new BaseOptions(
        baseUrl: baseurl,
        connectTimeout: Duration(milliseconds: 50000),
        receiveTimeout: Duration(milliseconds: 50000),
      );

      dio = new Dio(options);
      final response = await dio.get(url);
      final gradeList = response.data as List;
      return gradeList.map((grade) => GradeProduto.fromMap(grade)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<GradeProduto> fetchGradeProduto(int codProduto, String tamanho) async {
    String url = '';
    try {
      url = '/Produtos/Grades/$codProduto/$tamanho';
      final baseurl = await ConfigController.instance.getUrlBase();
      BaseOptions options = new BaseOptions(
        baseUrl: baseurl,
        connectTimeout: Duration(milliseconds: 50000),
        receiveTimeout: Duration(milliseconds: 50000),
      );

      dio = new Dio(options);
      final response = await dio.get(url);
      return GradeProduto.fromMap(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
