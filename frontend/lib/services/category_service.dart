import 'package:dio/dio.dart';

class CategoryService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://felixfrond-end-production.up.railway.app/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<List<dynamic>> getAll() async {
    final response = await _dio.get('/kategori');
    return response.data;
  }
}
