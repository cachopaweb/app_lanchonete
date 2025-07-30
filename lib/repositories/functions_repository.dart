import 'package:dio/dio.dart';

import '../Controller/Config.Controller.dart';

class FunctionsRepository {
  Future<int> fetchIncrementaGenerator(String generator) async {
    final url = await ConfigController.instance.getUrlBase();

    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    );

    Dio dio = Dio(options);
    try {
      final response = await dio
          .post('$url/v1/incrementa_generator', data: {'generator': generator});
      final data = response.data as Map<String, dynamic>;
      return data['codigo'] as int;
    } catch (e) {
      throw new Exception(e);
    }
  }
}
