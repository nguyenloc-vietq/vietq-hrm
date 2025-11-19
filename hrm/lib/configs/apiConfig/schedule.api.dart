import 'package:dio/dio.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/api_exceptions.dart';
import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';
import 'package:vietq_hrm/models/attendanceRecord.models.dart';
import 'package:vietq_hrm/models/schedule.module.dart';
import 'package:vietq_hrm/models/timeSheet.models.dart';

class ScheduleApi {
  final dio = DioClient().dio;

  Future<List<ScheduleModels>> fetchSchedule({String? today}) async {
    try {
      if(today != null){

        final response = await dio.get('/schedule/get-schedule', queryParameters: {
          'today': today,
        });
        final List<dynamic> rawList = response.data['data'];
        return (rawList as List)
            .map<ScheduleModels>(
              (item) => ScheduleModels.fromJson(item as Map<String, dynamic>),
        )
            .toList();
      }else{
        final response = await dio.get('/schedule/get-schedule');
        final List<dynamic> rawList = response.data['data'];
        return (rawList as List)
            .map<ScheduleModels>(
              (item) => ScheduleModels.fromJson(item as Map<String, dynamic>),
        )
            .toList();
      }

    } on DioException catch (e) {
      print("#==========> ${e.message}");
      final handle = handleDioError(e);
      throw handle;
    }
  }

  Future<TimeSheetModels> fetchTimeSheet({String? today}) async {
    if(today != null){
      final response = await dio.get('/attendance/time-sheet', queryParameters: {
        'today': today,
      });
      final data = response.data['data'];
      return TimeSheetModels.fromJson(data);
    }
    try {
      final response = await dio.get('/attendance/time-sheet');
      final data = response.data['data'];
      return TimeSheetModels.fromJson(data);
    }on DioException catch (e) {
      print("#==========> ${e.message}");
      final handle = handleDioError(e);
      throw handle;
    }
  }

  Future<AttendanceRecordModels> checkIn() async {
    try {
      final response = await dio.post('/attendance/check-in');
      final data = response.data['data'];
      return AttendanceRecordModels.fromJson(data);
    }on DioException catch (e) {
      print("#==========> ${e.message}");
      final handle = handleDioError(e);
      throw handle;
    }
  }

  Future<AttendanceRecordModels> checkOut() async {
    try {
      final response = await dio.post('/attendance/check-out');
      final data = response.data['data'];
      return AttendanceRecordModels.fromJson(data);
    }on DioException catch (e) {
      print("#==========> ${e.message}");
      final handle = handleDioError(e);
      throw handle;
    }
  }

  Future<void> updateStatusSchedules() async {
    try {
      await dio.get('/schedule/update-status-schedules');
      print("#==========> UPDATE STATUS SCHEDULES IS SUCCESS!:");
    } on DioException catch (e) {
      print("#==========> ${e.message}");
      final handle = handleDioError(e);
      throw handle;
    }
  }
}
