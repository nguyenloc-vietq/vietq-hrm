import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';

class UserApi {
  final dio = DioClient().dio;

  Future<Map<String,dynamic>> getProfile() async {
    try {
      final response = await dio.get('/user/profile');
      return response.data['data'];
    } on DioException catch(e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await dio.put('/user/update', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });
      return response.data['data'];
    } on DioException catch(e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }
}