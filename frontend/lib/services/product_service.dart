import 'package:dio/dio.dart';

class ProductService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://felixfrond-end-production.up.railway.app/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<List<dynamic>> getAll() async {
    final response = await _dio.get('/barang');
    return response.data;
  }

  static Future<Map<String, dynamic>> getById(int id) async {
    final response = await _dio.get('/barang/$id');
    return response.data;
  }

  static Future<void> create(Map<String, dynamic> data) async {
    await _dio.post('/barang', data: data);
  }

  static Future<void> update(int id, Map<String, dynamic> data) async {
    await _dio.put('/barang/$id', data: data);
  }

  static Future<void> delete(int id) async {
    await _dio.delete('/barang/$id');
  }

  static Future<void> deleteBulk(List<int> ids) async {
    await _dio.delete('/barang/bulk', data: {"ids": ids});
  }
}
