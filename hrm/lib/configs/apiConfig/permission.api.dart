import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';

class PremissionApi {
  final dio = DioClient().dio;

  Future<Map<String, dynamic>> getPermissions({String? status}) async {
      try {
        final response = await dio.get(
          '/permission/my-permissions'
        );
        return response.data;
      } on DioException catch (e) {
        final handled = handleDioError(e);
        print('Gọi API lấy danh sách thất bại: $handled');
        throw handled;
      }
  }
}
