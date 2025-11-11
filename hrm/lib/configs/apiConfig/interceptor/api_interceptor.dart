import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/routers/routes.config.dart';

class ApiInterceptor extends Interceptor {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:1900/api'));
  final List<String> publicRoutes = [
    '/auth/login',
    '/auth/forgot-password',
  ];
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _getToken();
      print(options.path);
      if (publicRoutes.any((r) => options.path.contains(r))) {
        print(publicRoutes.any((r) => options.path.contains(r)));
        print("Public route");
        return handler.next(options);
      }
      final checkRes = await dio.get('/auth/check-auth',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      print("#================> Check Authen" + checkRes.data.toString());
      // Nếu check ok -> tiếp tục request
      if (checkRes.statusCode == 200) {

        options.headers['Authorization'] = 'Bearer $token';
        print('--> ${options.baseUrl} ${options.method} ${options.path}');
        print('Headers: ${options.headers}');
        print('Body: ${options.data}');
        return handler.next(options);
      }
    } on DioException catch (e) {
      // Nếu server trả 401 -> logout
      if (e.response?.statusCode == 401) {
        //logout
        SharedPreferencesConfig.delete('users');
        appRouter.go('/login');
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Unauthorized - Token expired',
            type: DioExceptionType.cancel,
          ),
        );
      }
    }
    // Nếu lỗi khác hoặc token null thì cũng logout
    SharedPreferencesConfig.delete('users');
    return handler.reject(
      DioException(
        requestOptions: options,
        error: 'Token invalid or missing',
        type: DioExceptionType.cancel,
      ),
    );
  }



  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('<-- ${response.statusCode} ${response.requestOptions.path}');
    print('Response: ${response.data}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('Message: ${err.response}');
    final handledError = handleDioError(err);
    // print('Handled Error: $handledError.message');
    return handler.next(err);
  }

  Future<String?> _getToken() async {
    final userJson = SharedPreferencesConfig.users;
    if (userJson != null && userJson.isNotEmpty) {
      final user = jsonDecode(userJson);
      try {
        return user['accessToken'] as String?;
      } catch (e) {
        print('Lỗi khi đọc token: $e');
        return null;
      }
    }

  }
}
