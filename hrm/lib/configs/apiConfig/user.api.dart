import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';
import 'package:vietq_hrm/models/user.models.dart';

class UserApi {
  final dio = DioClient().dio;

  Future<UserModels> getProfile() async {
    try {
      final response = await dio.get('/user/profile');
      return UserModels.fromJson(response.data['data']);
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
        'fullName': name,
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
  Future<Map<String, dynamic>> updateAvatar(FormData data) async {
    try {
      final response = await dio.post('/user/upload-avatar', data: data);
      return response.data['data'];
    } on DioException catch(e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }
  Future<void> changePassword(String oldPasss, String password) async {
    try{
      await dio.post('/user/change-password', data: {
        'oldPassword': oldPasss,
        'newPassword': password,
      });
    }on DioException catch (e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
}
}