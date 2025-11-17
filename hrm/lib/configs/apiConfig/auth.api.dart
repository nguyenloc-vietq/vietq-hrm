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

  Future<void> sentOtp(String email) async {
    try {
      final response = await dio.post('/auth/sent-otp', data: {
        'email': email,
      });
      print(response.data);
    } on DioException catch(e) {
      print(e);
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }

  Future<Map<String,dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await dio.post('/auth/validate-otp', data: {
        'email': email,
        'otp': otp,
      });
      return response.data['data'];
    } on DioException catch(e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }

  Future<Map<String,dynamic>> changePassword({
    required String email,
    required String password,
    required String passwordConfirm,
    required String token,
  }) async {
    try {
      final response = await dio.post('/auth/change-password', data: {
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        'token': token,
      });
      return response.data['data'];
    } on DioException catch(e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }
}