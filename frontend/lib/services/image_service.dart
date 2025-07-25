import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ImageService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://felixfrond-end-production.up.railway.app/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  static Future<String> uploadImage(File file) async {
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType),
      ),
    });

    final response = await _dio.post('/media', data: formData);

    if (response.statusCode == 201 && response.data['url'] != null) {
      return response.data['url'];
    } else {
      throw Exception('Upload gagal: ${response.statusCode}');
    }
  }
}
