import 'package:vietq_hrm/configs/apiConfig/interceptor/dio_client.dart';

class PayrollApi {
  final dio = DioClient().dio;

  Future<List<dynamic>> getListPayslip() async {
    try {
      final response = await dio.get('/payroll/list-payslips');
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to load payroll details');
      }
    } catch (e) {
      throw Exception('Failed to load payroll details');
    }
  }
}
