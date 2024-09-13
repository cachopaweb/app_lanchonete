import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/mesa_model.dart';
import 'package:dio/dio.dart';

class MesaService {
  BaseOptions? options;
  late Dio dio;

  Future<List<Mesa>> fetchMesas() async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.get<List>('/Mesas');
    final resultado =
        response.data!.map((json) => Mesa.fromJson(json)).toList();
    return resultado;
  }

  Future<Mesa> fetchMesa(int codMesa) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.get('/Mesas/$codMesa');
    final resultado = Mesa.fromJson(response.data);
    return resultado;
  }
}
