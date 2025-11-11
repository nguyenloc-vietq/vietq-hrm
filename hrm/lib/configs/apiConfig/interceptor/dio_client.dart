import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late Dio dio;
  final API_ENDPOINT = dotenv.env['API_ENDPOINT'];
  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: API_ENDPOINT ?? '',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(ApiInterceptor());
  }
}
