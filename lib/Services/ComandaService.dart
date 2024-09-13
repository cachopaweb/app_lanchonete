import 'dart:async';

import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Models/comanda_model.dart';
import 'package:lanchonete/Models/itemComPro_model.dart';
import 'package:dio/dio.dart';

class ComandaService {
  late Dio dio;
  Future<List<Comanda>> fetchComandas() async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.get<List>('/Comandas');
    final resultado =
        response.data!.map((json) => Comanda.fromJson(json)).toList();
    return resultado;
  }

  Future<bool> criaComanda(Comanda comanda) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.post('/Comandas', data: comanda.toJson());
    return response.statusCode == 201;
  }

  Future<Comanda> fetchComanda(int? codigo) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.get('/Comandas/$codigo');
    Comanda resultado = Comanda();
    try {
      resultado = Comanda.fromJson(response.data);
    } catch (e) {
      print(e.toString());
    }
    return resultado;
  }

  Future<bool> encerrarComanda(int? codigo) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.put('/Comandas/$codigo/encerrar');
    return response.statusCode == 200;
  }

  Future<bool> atualizarComanda(Comanda comanda) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response =
        await dio.put('/Comandas/${comanda.mesa}', data: comanda.toJson());
    return response.statusCode == 200;
  }

  Future<ItemComPro> fetchItemComPro(int codigo) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.get('/Comandas/item/$codigo');
    ItemComPro resultado = ItemComPro();
    try {
      resultado = ItemComPro.fromJson(response.data);
    } catch (e) {
      print(e.toString());
    }
    return resultado;
  }

  Future<bool> deletarItemComanda(int? codigo) async {
    final url = await ConfigController.instance.getUrlBase();
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    dio = new Dio(options);
    final response = await dio.delete('/Comandas/$codigo/itens');
    return response.statusCode == 200;
  }
}
