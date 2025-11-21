import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(super.message) : super(statusCode: 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message) : super(statusCode: 401);

}

class NotFoundException extends ApiException {
  NotFoundException(super.message) : super(statusCode: 404);
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException(super.message) : super(statusCode: 500);
}

class NoInternetException extends ApiException {
  NoInternetException(super.message);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}


ApiException handleDioError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return TimeoutException("Yêu cầu hết thời gian phản hồi.");
  } else if (error.type == DioExceptionType.badResponse) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data['message'] ?? "Lỗi không xác định";
    
    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 404:
        return NotFoundException(message);
      case 500:
        return InternalServerErrorException(message);
      default:
        return ApiException(message, statusCode: statusCode);
    }
  } else if (error.type == DioExceptionType.unknown) {
    return NoInternetException("Không có kết nối Internet.");
  } else {
    return ApiException("Đã xảy ra lỗi không xác định.");
  }
}
