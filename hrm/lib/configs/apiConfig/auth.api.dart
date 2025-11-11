import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';

class AuthApi {
  final dio = DioClient().dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      print(response.data);
      return response.data['data'];
    } on DioException catch (e) {
      print(e);
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }

  Future<List<dynamic>> getListShift() async{
    try {
      final response = await dio.get('/shift/get-list-shift');
      return response.data['data'];
    } on DioException catch (e) {
      print(e);
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }
}