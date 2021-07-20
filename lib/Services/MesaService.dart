import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/mesa_model.dart';
import 'package:dio/dio.dart';

class MesaService {
  BaseOptions options;
  Dio dio;

  Future<List<Mesa>> fetchMesas() async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );

    dio = new Dio(options);
    final response = await dio.get<List>('/Mesas');
    final resultado = response.data.map((json) => Mesa.fromJson(json)).toList();
    return resultado;
  }

  Future<Mesa> fetchMesa(int codMesa) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: 50000,
      receiveTimeout: 50000,
    );

    dio = new Dio(options);
    final response = await dio.get('/Mesas/$codMesa');
    final resultado = Mesa.fromJson(response.data);
    return resultado;
  }
}
