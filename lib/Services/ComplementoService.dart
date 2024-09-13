import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/complementos_model.dart';
import 'package:dio/dio.dart';

Future<List<Complementos>> fetchComplementos(int grupo) async {
  final url = await ConfigController.instance.getUrlBase();
  BaseOptions options = new BaseOptions(
    baseUrl: url,
    connectTimeout: Duration(milliseconds: 50000),
    receiveTimeout: Duration(milliseconds: 50000),
  );

  Dio dio = new Dio(options);
  final response = await dio.get<List>('/Complementos/$grupo');
  final resultado =
      response.data!.map((json) => Complementos.fromJson(json)).toList();
  return resultado;
}
