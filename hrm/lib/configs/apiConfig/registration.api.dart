import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';

class RegistrationApi {
  final dio = DioClient().dio;

  Future createRegistration(data) async {
    try {
      await dio.post('/registration/create', data: data);

    } on DioException catch(e) {
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }
  Future<Map<String, dynamic>> listRegistrations({String? status}) async {
      try {
        final response = await dio.get(
          '/registration/list-registrations',
          queryParameters: status != null ? {'status': status} : null,
        );

        return response.data;
      } on DioException catch (e) {
        final handled = handleDioError(e);
        print('Gọi API lấy danh sách thất bại: $handled');
        throw handled;
      }
  }

  Future approveRegistration(Map<String, dynamic> data) async {
      try {
        final response = await dio.post('/registration/approve', data: data);
        return response.data;
      } on DioException catch (e) {
        final handled = handleDioError(e);
        print('Gọi API Approve thất bại: $handled');
        throw handled;
      }
    }

    // 4. Từ chối đơn (Reject)
    Future rejectRegistration(Map<String, dynamic> data) async {
      try {
        final response = await dio.post('/registration/reject', data: data);
        return response.data;
      } on DioException catch (e) {
        final handled = handleDioError(e);
        print('Gọi API Reject thất bại: $handled');
        throw handled;
      }
    }
    Future<Map<String, dynamic>> listApprovals() async {
      try {
        final response = await dio.get('/registration/list-approvals');
        return response.data;
      } on DioException catch (e) {
        throw handleDioError(e);
      }
    }
}
