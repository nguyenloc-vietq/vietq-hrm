import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';
import 'package:vietq_hrm/models/notification.models.dart';

class NotificationApi {
  final dio = DioClient().dio;

  Future<List<NotificationModel>> fetchNotification({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get('/notification/user/list-notification');
      final List<dynamic> rawList = response.data['data'];
      return (rawList as List)
          .map<NotificationModel>((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      print(e);
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }

  Future<NotificationModel> getDetailNotification({
    required String id,
  }) async {
    try {
      final response = await dio.get('/notification/user/notifications/$id');
      return NotificationModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      print(e);
      final handled = handleDioError(e);
      print(' Gọi API thất bại: ${handled}');
      throw handled;
    }
  }
}